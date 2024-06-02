import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/config/messages.dart';

class GalleryController extends GetxController {
  PageController pageController = PageController();
  var posts = <Map<String, dynamic>>[].obs;
  var filteredPosts = <Map<String, dynamic>>[].obs;
  var selectedIndex = 0.obs;
  var currentPage = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPostsFromFirestore();
  }

  void fetchPostsFromFirestore() async {
    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      var fetchedPosts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['dateTime'] = (data['dateTime'] as Timestamp).toDate();
        data['id'] = doc.id; // Add this line to store document ID
        return data;
      }).toList();
      fetchedPosts.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
      posts.value = fetchedPosts;
      filteredPosts.value = List.from(posts);
    } catch (error) {
      errorMessage("Error fetching posts from Firestore.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPostToFirestore(Map<String, dynamic> post) async {
    isLoading.value = true;

    if (post['files'] != null && post['files'].isNotEmpty) {
      // Files are selected, so upload them
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
    }

    if (post['title'].isEmpty || post['description'].isEmpty) {
      // Title or description is empty, do not proceed with addition
      isLoading.value = false;
      errorMessage("يرجى إدخال عنوان ووصف للمنشور");
      return;
    }

    await FirebaseFirestore.instance.collection('posts').add(post);

    isLoading.value = false;
    fetchPostsFromFirestore();
    successMessage("تم إضافة المنشور بنجاح");
  }

  Future<void> editPostInFirestore(String postId,
      Map<String, dynamic> updatedData, Map<String, dynamic> postData) async {
    isLoading.value = true;

    if (updatedData['files'] is List<File>) {
      // New files are selected, so we need to upload them and update their URLs
      List<String> fileUrls = [];
      List<String> oldFileUrls =
          List<String>.from(postData['files']); // Store the old file URLs

      for (File file in updatedData['files']) {
        String fileName = file.path.split('/').last;
        Reference ref =
            FirebaseStorage.instance.ref().child('posts').child(fileName);
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();
        fileUrls.add(url);
      }
      updatedData['files'] = fileUrls;

      // Delete old files from Firebase Storage
      for (String oldUrl in oldFileUrls) {
        await FirebaseStorage.instance.refFromURL(oldUrl).delete();
      }
    }

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update(updatedData);

    isLoading.value = false;
    fetchPostsFromFirestore();
    successMessage("تم تعديل المنشور بنجاح");
  }

  void deletePost(int index, BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "!تأكيد الحذف",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "هل أنت متأكد أنك تريد حذف هذا المنشور؟",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
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
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("تأكيد"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
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

    if (confirmDelete == true) {
      try {
        DocumentReference postRef = FirebaseFirestore.instance
            .collection('posts')
            .doc(posts[index]['id']);

        await postRef.delete();

        for (String fileUrl in posts[index]['files']) {
          await FirebaseStorage.instance.refFromURL(fileUrl).delete();
        }

        posts.removeAt(index);
        filteredPosts.value = List.from(posts);

        successMessage("تم حذف المنشور بنجاح ");
      } catch (error) {
        errorMessage("حدث خطأ أثناء حذف المنشور.");
      }
    }
  }

  void filterPosts(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      filteredPosts.value = List.from(posts);
    } else if (index == 1) {
      filteredPosts.value =
          posts.where((post) => post['isImages'].contains(true)).toList();
    } else if (index == 2) {
      filteredPosts.value =
          posts.where((post) => post['isImages'].contains(false)).toList();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
