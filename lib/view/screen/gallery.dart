import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:uqba_elibrary/controller/gallery_controller.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';
import 'package:uqba_elibrary/view/screen/GalleryHeroScreen.dart';
import 'package:uqba_elibrary/view/widget/book/operator/custom_popupmenubutton.dart';
import 'package:uqba_elibrary/view/widget/gallery/addpostdialog.dart';
import 'package:uqba_elibrary/view/widget/gallery/editpostdialog.dart';
import 'package:uqba_elibrary/view/widget/gallery/videoprovider.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final LoginController authController = Get.find<LoginController>();
  final GalleryController galleryController = Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: buildAppBar(context),
        body: Obx(() {
          return Stack(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: buildUI(),
              ),
              if (galleryController.isLoading.value) buildLoadingOverlay(),
            ],
          );
        }),
        floatingActionButton: Obx(() {
          return authController.isAuthorizedUser.value
              ? buildFloatingActionButton(context)
              : SizedBox();
        }),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text('معرض الصور'),
      bottom: TabBar(
        indicatorColor: const Color(0xFF573720),
        labelColor: const Color(0xFF573720),
        unselectedLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF573720),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelColor: Colors.black,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3.0,
            color: Color(0xFF573720),
          ),
          insets: EdgeInsets.symmetric(horizontal: 50.0),
        ),
        onTap: (index) {
          galleryController.filterPosts(index);
        },
        tabs: const [
          Tab(text: 'الكل'),
          Tab(text: 'الصور'),
          Tab(text: 'الفيديوهات'),
        ],
      ),
    );
  }

  Widget buildUI() {
    return Obx(() {
      if (galleryController.selectedIndex.value == 0) {
        return buildAllPostsList();
      } else {
        return buildMediaGrid();
      }
    });
  }

  Widget buildAllPostsList() {
    return ListView.builder(
      itemCount: galleryController.filteredPosts.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> post = galleryController.filteredPosts[index];
        return buildPostCard(context, post, index);
      },
    );
  }

  Widget buildPostCard(
      BuildContext context, Map<String, dynamic> post, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryHeroScreen(
              fileUrls: List<String>.from(post['files']),
              isImages: List<bool>.from(post['isImages']),
              initialIndex: 0,
              title: post['title'],
              description: post['description'],
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: AspectRatio(
                    aspectRatio: 3 / 2, // Adjust aspect ratio as needed
                    child: buildMediaPreview(post),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: authController.isAuthorizedUser.value
                      ? CustomPopUpMenuButton(
                          icon: Icons.more_vert,
                          onPressedDelete: () {
                            galleryController.deletePost(index, context);
                          },
                          onPressedEdit: () {
                            var postToEdit = galleryController.posts[index];
                            showDialog(
                              context: context,
                              builder: (context) => EditPostDialog(
                                post: postToEdit,
                                onPostEdited: (postId, updatedData) {
                                  galleryController.editPostInFirestore(
                                      post['id'], updatedData, post);
                                },
                              ),
                            );
                          },
                        )
                      : SizedBox(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  ReadMoreText(
                    post['description'],
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'قراءة المزيد',
                    trimExpandedText: ' اظهار اقل ',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMediaPreview(Map<String, dynamic> post) {
    if (post['files'].isEmpty) {
      return Container(color: Colors.grey[300]); // Placeholder for no media
    }

    if (post['isImages'].contains(true)) {
      return Image.network(
        post['files'][0],
        fit: BoxFit.cover,
      );
    } else if (post['isImages'].contains(false)) {
      return VideoProvider(
        url: post['files'][0],
        autoPlay: false,
      );
    } else {
      return Container(
          color: Colors.grey[300]); // Placeholder for unknown media type
    }
  }

  Widget buildMediaGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: galleryController.filteredPosts.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> post = galleryController.filteredPosts[index];
        bool hasImages = post['isImages'].contains(true);
        bool hasVideos = post['isImages'].contains(false);

        return GestureDetector(
          onTap: () {
            if (post['files'].isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GalleryHeroScreen(
                    fileUrls: List<String>.from(post['files']),
                    isImages: List<bool>.from(post['isImages']),
                    initialIndex: 0,
                    title: post['title'],
                    description: post['description'],
                  ),
                ),
              );
            }
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                if (hasImages)
                  Positioned.fill(
                    child: Image.network(
                      post['files'][0],
                      fit: BoxFit.cover,
                    ),
                  ),
                if (hasVideos)
                  Positioned.fill(
                    child: VideoProvider(
                      url: post['files'][0],
                      autoPlay: false,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AddPostDialog(
            onPostAdded: (post) async {
              post['dateTime'] = DateTime.now();
              await galleryController.addPostToFirestore(post);
              galleryController.fetchPostsFromFirestore();
            },
          ),
        );
      },
      child: const Icon(
        Icons.add,
        color: Color(0xFF573720),
      ),
    );
  }

  Widget buildLoadingOverlay() {
    return Stack(
      children: [
        const ModalBarrier(
          color: Colors.grey,
          dismissible: false,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: galleryController.uploadProgress.value,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF573720)),
                strokeWidth: 6.0,
              ),
              const SizedBox(height: 10),
              Obx(() {
                double progress = galleryController.uploadProgress.value * 100;
                return Text(
                  "${progress.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
