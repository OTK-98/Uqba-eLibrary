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
  GalleryController galleryController = Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('معرض الصور'),
          bottom: TabBar(
            indicatorColor: Color(0xFF573720),
            labelColor: Color(0xFF573720),
            unselectedLabelStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            labelStyle: TextStyle(
              color: Color(0xFF573720),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: Colors.black,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3.0,
                color: Color(0xFF573720),
              ),
              insets: EdgeInsets.symmetric(horizontal: 50.0),
            ),
            onTap: (index) {
              galleryController.filterPosts(index);
            },
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'الصور'),
              Tab(text: 'الفيديوهات'),
            ],
          ),
        ),
        body: Obx(() {
          return Stack(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: buildUI(),
              ),
              if (galleryController.isLoading.value)
                Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF573720),
                  ),
                ),
            ],
          );
        }),
        floatingActionButton: Obx(() {
          return authController.isAuthorizedUser.value
              ? FloatingActionButton(
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
                  child: Icon(
                    Icons.add,
                    color: Color(0xFF573720),
                  ),
                )
              : SizedBox(); // If not authorized user, show an empty SizedBox
        }),
      ),
    );
  }

  Widget buildUI() {
    return Obx(() {
      if (galleryController.selectedIndex.value == 0) {
        // "All" tab: Original display
        return ListView.builder(
          itemCount: galleryController.filteredPosts.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> post = galleryController.filteredPosts[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryHeroScreen(
                      fileUrls: List<String>.from(post['files']),
                      isImages: List<bool>.from(post['isImages']),
                      initialIndex: 0,
                      title: post['title'], // Pass the title
                      description: post['description'], // Pass the description
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              post['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          authController.isAuthorizedUser.value
                              ? CustomPopUpMenuButton(
                                  icon: Icons.more_vert,
                                  onPressedDelete: () {
                                    galleryController.deletePost(
                                        index, context);
                                  },
                                  onPressedEdit: () {
                                    // Retrieve the post to be edited using the index
                                    var postToEdit =
                                        galleryController.posts[index];

                                    // Show the EditPostDialog
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
                        ],
                      ),
                    ),
                    if (post['files'].isNotEmpty) // Check if files are uploaded
                      Container(
                        height:
                            400, // Adjust height based on whether media is uploaded
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: galleryController.pageController,
                              itemCount: post['files'].length,
                              itemBuilder: (context, fileIndex) {
                                return post['isImages'][fileIndex]
                                    ? Image.network(
                                        post['files'][fileIndex],
                                        fit: BoxFit.contain,
                                      )
                                    : VideoProvider(
                                        url: post['files'][fileIndex],
                                        autoPlay: false,
                                      );
                              },
                              onPageChanged: (int page) {
                                galleryController.currentPage.value = page;
                              },
                            ),
                            if (post['files'].length > 1)
                              Positioned(
                                bottom: 8,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    post['files'].length,
                                    (index) => Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index ==
                                                galleryController
                                                    .currentPage.value
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ReadMoreText(
                        post['description'],
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'قراءة المزيد',
                        trimExpandedText: ' اظهار اقل ',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // "Images" and "Videos" tabs: Adjust layout based on media type
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
                  // Only navigate if files are present
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryHeroScreen(
                        fileUrls: List<String>.from(post['files']),
                        isImages: List<bool>.from(post['isImages']),
                        initialIndex: 0,
                        title: post['title'], // Pass the title
                        description:
                            post['description'], // Pass the description
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
                          post['files'][0], // Display first image
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (hasVideos)
                      Positioned.fill(
                        child: VideoProvider(
                          url: post['files'][0], // Display first video
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
    });
  }
}
