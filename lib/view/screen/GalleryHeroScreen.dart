import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/view/widget/gallery/videoprovider.dart';
import 'package:readmore/readmore.dart';
import 'package:uqba_elibrary/view/widget/book/operator/custom_popupmenubutton.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';
import 'package:uqba_elibrary/controller/gallery_controller.dart';
import 'package:uqba_elibrary/view/widget/gallery/editpostdialog.dart';

class GalleryHeroScreen extends StatefulWidget {
  final List<String> fileUrls;
  final List<bool> isImages;
  final int initialIndex;
  final String title;
  final String description;

  const GalleryHeroScreen({
    required this.fileUrls,
    required this.isImages,
    required this.initialIndex,
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  _GalleryHeroScreenState createState() => _GalleryHeroScreenState();
}

class _GalleryHeroScreenState extends State<GalleryHeroScreen> {
  final LoginController authController = Get.find<LoginController>();
  final GalleryController galleryController = Get.put(GalleryController());

  bool _isPlaying = false;
  bool _showControls = true; // Initially show controls
  final Map<int, GlobalKey<VideoProviderState>> _videoKeys = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.fileUrls.length; i++) {
      if (!widget.isImages[i]) {
        _videoKeys[i] = GlobalKey<VideoProviderState>();
      }
    }
    _isPlaying = !widget.isImages[widget.initialIndex];
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls; // Toggle controls visibility
    });
  }

  void _playPauseVideo(int index) {
    final videoKey = _videoKeys[index]!;
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _showControls = false; // Hide controls when video starts playing
        videoKey.currentState?.play();
      } else {
        _showControls = true; // Show controls when video is paused
        videoKey.currentState?.pause();
      }
    });
  }

  void _enterFullscreen(BuildContext context, int index) {
    final videoKey = _videoKeys[index]!;
    final currentPosition = videoKey.currentState!.controller.value.position;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: AspectRatio(
              aspectRatio: videoKey.currentState!.controller.value.aspectRatio,
              child: VideoProvider(
                file: null,
                url: widget.fileUrls[index],
                autoPlay: true,
                initialPosition: currentPosition, // Pass the current position
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.fullscreen_exit),
          ),
        ),
      ),
    ).then((_) {
      // Restore video playback state when returning from fullscreen
      if (_isPlaying) {
        videoKey.currentState?.play();
      } else {
        videoKey.currentState?.pause();
      }
    });

    // Pause the video when entering fullscreen mode
    videoKey.currentState?.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: Obx(() {
            return authController.isAuthorizedUser.value
                ? CustomPopUpMenuButton(
                    icon: Icons.more_vert,
                    onPressedDelete: () {
                      galleryController.deletePost(
                          widget.initialIndex, context);
                    },
                    onPressedEdit: () {
                      var postToEdit =
                          galleryController.posts[widget.initialIndex];
                      showDialog(
                        context: context,
                        builder: (context) => EditPostDialog(
                          post: postToEdit,
                          onPostEdited: (postId, updatedData) {
                            galleryController.editPostInFirestore(
                                postToEdit['id'], updatedData, postToEdit);
                          },
                        ),
                      );
                    },
                  )
                : SizedBox();
          }),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            PageView.builder(
              itemCount: widget.fileUrls.length,
              controller: PageController(initialPage: widget.initialIndex),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _toggleControlsVisibility(); // Toggle controls visibility on tap
                    if (!widget.isImages[index]) {
                      Navigator.pop(context);
                    }
                  },
                  child: Hero(
                    tag: 'post_${widget.fileUrls[index]}',
                    child: widget.isImages[index]
                        ? Image.network(
                            widget.fileUrls[index],
                            fit: BoxFit.contain,
                          )
                        : Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                VideoProvider(
                                  key: _videoKeys[index]!,
                                  url: widget.fileUrls[index],
                                  autoPlay: index == widget.initialIndex &&
                                      _isPlaying,
                                ),
                                if (_showControls) // Show controls if not hidden
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _playPauseVideo(index),
                                  ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: IconButton(
                                    icon: Icon(Icons.fullscreen),
                                    color: Colors.white,
                                    onPressed: () =>
                                        _enterFullscreen(context, index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    ReadMoreText(
                      widget.description,
                      trimLines: 4,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'قراءة المزيد',
                      trimExpandedText: ' اظهار اقل ',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
