import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/config/messages.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final LoginController authController = Get.find<LoginController>();
  bool isLoading = false; // Add loading state variable

  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> filteredPosts = [];
  int selectedIndex = 0; // Added for TabBar

  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchPostsFromFirestore();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void fetchPostsFromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    setState(() {
      posts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['dateTime'] = (data['dateTime'] as Timestamp).toDate();
        data['id'] = doc.id; // Add this line to store document ID
        return data;
      }).toList();
      posts.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
      filteredPosts = List.from(posts);
    });
  }

  Future<void> addPostToFirestore(Map<String, dynamic> post) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    List<String> fileUrls = [];
    for (File file in post['files']) {
      String fileName = file.path.split('/').last;
      Reference ref =
          FirebaseStorage.instance.ref().child('posts').child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      fileUrls.add(url);
    }

    post['files'] = fileUrls;
    await FirebaseFirestore.instance.collection('posts').add(post);
    setState(() {
      isLoading = false; // Set loading state to false after upload
    });
  }

  void filterPosts(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        filteredPosts = List.from(posts);
      } else if (index == 1) {
        filteredPosts =
            posts.where((post) => post['isImages'].contains(true)).toList();
      } else if (index == 2) {
        filteredPosts =
            posts.where((post) => post['isImages'].contains(false)).toList();
      }
    });
  }

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
                fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3.0,
                color: Color(0xFF573720),
              ),
              insets: EdgeInsets.symmetric(horizontal: 50.0),
            ),
            onTap: filterPosts,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'الصور'),
              Tab(text: 'الفيديوهات'),
            ],
          ),
        ),
        body: Stack(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: buildUI(),
            ),
            // Show loading indicator conditionally based on isLoading state
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF573720),
                ),
              ),
          ],
        ),
        floatingActionButton: addPostButton(),
      ),
    );
  }

  Widget addPostButton() {
    return authController.isAuthorizedUser.value
        ? FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddPostDialog(
                  onPostAdded: (post) async {
                    post['dateTime'] = DateTime.now();
                    await addPostToFirestore(post);
                    fetchPostsFromFirestore();
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
  }

  Widget buildUI() {
    if (selectedIndex == 0) {
      // "All" tab: Original display
      return ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> post = filteredPosts[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GalleryHeroScreen(
                    fileUrls: List<String>.from(post['files']),
                    isImages: List<bool>.from(post['isImages']),
                    initialIndex: 0,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          post['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            authController.isAuthorizedUser.value
                                ? IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      // Call deletePost method with post index
                                      deletePost(index);
                                    },
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 400,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
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
                            setState(() {
                              _currentPage = page;
                            });
                          },
                        ),
                        if (post['files'].length > 1) // Add dots indicator
                          Positioned(
                            bottom: 8,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                post['files'].length,
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == _currentPage
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
                    child: Text(
                      post['description'],
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
      // "Images" and "Videos" tabs
      return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns in the grid
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0, // Adjust the aspect ratio to your preference
        ),
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> post = filteredPosts[index];
          bool hasMultipleFiles = post['files'].length > 1;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GalleryHeroScreen(
                    fileUrls: List<String>.from(post['files']),
                    isImages: List<bool>.from(post['isImages']),
                    initialIndex: 0,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: post['files'].length,
                      itemBuilder: (context, fileIndex) {
                        return post['isImages'][fileIndex]
                            ? Image.network(
                                post['files'][fileIndex],
                                fit: BoxFit.cover,
                              )
                            : VideoProvider(
                                url: post['files'][fileIndex],
                                autoPlay: false,
                              );
                      },
                    ),
                  ),
                  if (hasMultipleFiles) // Add multiple files indicator
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.photo_library,
                        color: Color(0xFF573720),
                        size: 24,
                      ),
                    ),
                  if (post['isImages'].contains(false))
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white.withOpacity(0.7),
                          size: 50,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void deletePost(int index) async {
    // Confirm deletion with a dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "!تأكيد الحذف",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red, // Custom color for the title
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "هل أنت متأكد أنك تريد حذف هذا المنشور؟",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black, // Custom color for the content
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Colors.red, // Custom text color for Confirm button
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("تأكيد"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor:
                      Colors.grey[300], // Custom text color for Cancel button
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("إلغاء"),
              ),
            ],
          ),
        ],
      ),
    );

    // If user confirms deletion, proceed with deletion
    if (confirmDelete == true) {
      try {
        // Get the document reference
        DocumentReference postRef = FirebaseFirestore.instance
            .collection('posts')
            .doc(posts[index]['id']);

        // Delete post document from Firestore using the reference
        await postRef.delete();

        // Delete files from Firebase Storage
        for (String fileUrl in posts[index]['files']) {
          await FirebaseStorage.instance.refFromURL(fileUrl).delete();
        }

        // Remove the deleted post from the local list
        setState(() {
          posts.removeAt(index);
          filteredPosts = List.from(posts);
        });

        successMessage("تم حذف المنشور بنجاح ");
      } catch (error) {
        successMessage("حدث خطأ أثناء حذف المنشور.");
      }
    }
  }
}

class AddPostDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostAdded;

  const AddPostDialog({Key? key, required this.onPostAdded}) : super(key: key);

  @override
  _AddPostDialogState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<File> selectedMediaFiles = [];
  List<bool> isImages = [];

  Future<void> _selectMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        selectedMediaFiles = result.paths.map((path) => File(path!)).toList();
        isImages = result.files.map((file) {
          return ['jpg', 'jpeg', 'png', 'gif'].contains(file.extension);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text(
          'إضافة منشور',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان المنشور',
                  labelStyle: TextStyle(color: Color(0xFF573720)),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Color(0xFF573720)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Color(0xFF573720)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'وصف المنشور',
                  labelStyle: TextStyle(color: Color(0xFF573720)),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Color(0xFF573720)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Color(0xFF573720)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (selectedMediaFiles.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedMediaFiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isImages[index]
                            ? Image.file(selectedMediaFiles[index])
                            : VideoProvider(
                                file: selectedMediaFiles[index],
                                autoPlay: false,
                              ),
                      );
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: _selectMedia,
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Color(0xFF573720)),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'اختر الوسائط',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("إلغاء"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      selectedMediaFiles.isNotEmpty) {
                    widget.onPostAdded({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'files': selectedMediaFiles,
                      'isImages': isImages,
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text("نشر"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class VideoProvider extends StatefulWidget {
  final File? file;
  final String? url;
  final bool autoPlay;

  const VideoProvider({
    this.file,
    this.url,
    this.autoPlay = false,
    Key? key,
  }) : super(key: key);

  @override
  _VideoProviderState createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {
  late VideoPlayerController _controller;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.file != null) {
      _controller = VideoPlayerController.file(widget.file!)
        ..initialize().then((_) {
          setState(() {
            _isControllerInitialized = true;
          });
          if (widget.autoPlay) {
            _controller.play();
          }
        });
    } else if (widget.url != null) {
      _controller = VideoPlayerController.network(widget.url!)
        ..initialize().then((_) {
          setState(() {
            _isControllerInitialized = true;
          });
          if (widget.autoPlay) {
            _controller.play();
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isControllerInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                if (!widget.autoPlay)
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.play_circle_filled,
                          size: 50, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _controller.play();
                        });
                      },
                    ),
                  ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class GalleryHeroScreen extends StatelessWidget {
  final List<String> fileUrls;
  final List<bool> isImages;
  final int initialIndex;

  const GalleryHeroScreen({
    required this.fileUrls,
    required this.isImages,
    required this.initialIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: fileUrls.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (!isImages[index]) {
                Navigator.pop(context);
              }
            },
            child: Hero(
              tag: 'post_${fileUrls[index]}',
              child: isImages[index]
                  ? Image.network(fileUrls[index], fit: BoxFit.contain)
                  : VideoProvider(
                      url: fileUrls[index],
                      autoPlay: index == initialIndex,
                    ),
            ),
          );
        },
      ),
    );
  }
}
