import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uqba_elibrary/controller/bottom_nav_bar_controller.dart';
import 'package:uqba_elibrary/data/Repositories/books/book_repository.dart';
import 'package:uqba_elibrary/models/book_model.dart';
import 'package:uqba_elibrary/view/screen/gnav_bar.dart';
import 'package:uuid/uuid.dart';
import '../Config/Messages.dart';

class BookController extends GetxController {
  static BookController get instance => Get.find();
  final _bookRepository = Get.put(BookRepository());
  final CollectionReference categoryCollectionReference =
      FirebaseFirestore.instance.collection('Categories');
  BookController() {}

  final storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final fAuth = FirebaseAuth.instance;
  final isloading = false.obs;

  int index = 0;
  RxBool isImageUploading = false.obs;
  RxString imageUrl = "".obs;

  RxBool isPdfUploading = false.obs;
  RxString pdfUrl = "".obs;

  RxBool isPostUploading = true.obs;
  ImagePicker imagePicker = ImagePicker();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController author = TextEditingController();
  TextEditingController publisher = TextEditingController();
  TextEditingController edition = TextEditingController();
  TextEditingController pages = TextEditingController();
  // Store selectedPavillonId and selectedPavillonTitle
  RxString selectedPavillonId = "".obs;
  RxString selectedPavillonTitle = "".obs;
  // Store selectedCategoryId and selectedCategoryTitle
  RxString selectedCategoryId = "".obs;
  RxString selectedCategoryTitle = "".obs;
  TextEditingController wardrobe = TextEditingController();
  TextEditingController shelf = TextEditingController();
  TextEditingController code = TextEditingController();
  var bookData = RxList<BookModel>();
  var currentUserBooks = RxList<BookModel>();
  var currentUserBooksFavorie = RxList<BookModel>();

  String BookName = "";
  List searchResults = [];

  RxList<BookModel> featuredBooks = <BookModel>[].obs;
  RxList<BookModel> recentBooks = <BookModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedBooks();
    fetchRecentBooks();
    fetchFavoriteBooks();
    getUserBook();
  }

  Future<void> fetchFeaturedBooks() async {
    try {
      // Show Loader While loading catigories
      isloading.value = true;

      // Fetch books from data source (Firebase)
      final books = await _bookRepository.getFeaturedBooks();

      // Assign books
      featuredBooks.assignAll(books);
    } catch (e) {
      'Oh, Snap ${e}';
    } finally {}
    isloading.value = false;
  }

  Future<void> fetchRecentBooks() async {
    try {
      // Show Loader While loading catigories
      isloading.value = true;

      // Fetch books from data source (Firebase)
      final books = await _bookRepository.getRecentBooks();

      // Assign books
      recentBooks.assignAll(books);
    } catch (e) {
      'Oh, Snap ${e}';
    } finally {}
    isloading.value = false;
  }

  void pickImage() async {
    isImageUploading.value = true;
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image.path);
      uploadImageToFirebase(File(image.path));
    }
    isImageUploading.value = false;
  }

  void pickPDF() async {
    isPdfUploading.value = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.first.path!);

      if (file.existsSync()) {
        Uint8List fileBytes = await file.readAsBytes();
        String fileName = result.files.first.name;

        // Extract the name without the ".pdf" extension
        String bookNameWithoutExtension = fileName.replaceAll(".pdf", "");
        print("File Bytes: $fileBytes");

        final response =
            await storage.ref().child("Pdf/$fileName").putData(fileBytes);

        final downloadURL = await response.ref.getDownloadURL();
        pdfUrl.value = downloadURL;

        // Update the current book name without the extension
        BookName = bookNameWithoutExtension;

        print(downloadURL);
      } else {
        print("File does not exist");
      }
    } else {
      print("No file selected");
    }
    isPdfUploading.value = false;
  }

  void uploadImageToFirebase(File image) async {
    var uuid = Uuid();
    var filename = uuid.v1();
    var storageRef = storage.ref().child("Images/$filename");
    // ignore: unused_local_variable
    var response = await storageRef.putFile(image);
    String downloadURL = await storageRef.getDownloadURL();
    imageUrl.value = downloadURL;
    print("Download URL: $downloadURL");
    isImageUploading.value = false;
  }

  void createBook() async {
    isPostUploading.value = true;

    // Generate a new ID for the book
    String newBookId = db.collection("Books").doc().id;

    var newBook = BookModel(
      id: newBookId,
      title: title.text,
      author: author.text,
      description: description.text,
      publisher: publisher.text,
      edition: edition.text,
      pages: int.parse(pages.text),
      categoryId: selectedCategoryId.value,
      subCategoryId: selectedPavillonId.value,
      pavilion: selectedPavillonTitle.value,
      category: selectedCategoryTitle.value,
      wardrobe: int.parse(wardrobe.text),
      shelf: int.parse(shelf.text),
      code: int.parse(code.text),
      coverUrl: imageUrl.value,
      bookurl: pdfUrl.value,
      isFavorite: false, // Default value for isFavorite
      createdAt: Timestamp.fromDate(
          DateTime.now()), // Convert server timestamp to Timestamp
    );

    // Add book to "Books" collection
    await db.collection("Books").doc(newBookId).set(newBook.toJson());

    // Get the DocumentReference after the set operation
    DocumentReference bookRef = db.collection("Books").doc(newBookId);

    // Add book to "userBook" collection
    await db
        .collection("userBook")
        .doc(fAuth.currentUser!.uid)
        .collection("Books")
        .doc(newBookId)
        .set(newBook.toJson());

    // Add bookId and categoryId to "BookCategory" collection
    await db.collection("BookCategory").add({
      'bookId': newBookId,
      'categoryId': selectedPavillonId.value,
    });

    isPostUploading.value = false;
    // clear other fields and values...
    title.clear();
    author.clear();
    description.clear();
    publisher.clear();
    edition.clear();
    pages.clear();
    selectedPavillonId.value = "";
    selectedPavillonTitle.value = "";
    selectedCategoryId.value = "";
    selectedCategoryTitle.value = '';
    wardrobe.clear();
    shelf.clear();
    code.clear();
    imageUrl.value = "";
    pdfUrl.value = "";

    successMessage("تم إضافة الكتاب بنجاح", backgroundColor: Colors.green);
    fetchFeaturedBooks();
    fetchRecentBooks();
    getUserBook();
  }

  void getUserBook() async {
    currentUserBooks.clear();

    // Check if fAuth.currentUser is not null before accessing its properties
    if (fAuth.currentUser != null) {
      var books = await db
          .collection("userBook")
          .doc(fAuth.currentUser!.uid)
          .collection("Books")
          .get();

      for (var book in books.docs) {
        currentUserBooks.add(BookModel.fromSnapshot(book));
      }
    } else {
      // Handle the case where fAuth.currentUser is null
      print("Error: fAuth.currentUser is null");
      // You might want to throw an exception, log an error, or handle it appropriately.
    }
  }

  void updatePavillon(String selectedPavillonId, String selectedPavilloTitle) {
    // Your logic to use the selected category in another function
    print('Selected Category ID in BookController: $selectedPavillonId');
    print('Selected Category in BookController: $selectedPavilloTitle');

    // Store values in BookController
    this.selectedPavillonId.value = selectedPavillonId;
    this.selectedPavillonTitle.value = selectedPavilloTitle;
  }

  void updateCategory(String selectedCategoryId, String selectedCategoryTitle) {
    // Your logic to use the selected category in another function
    print('Selected Category ID in BookController: $selectedCategoryId');
    print('Selected Category in BookController: $selectedCategoryTitle');

    // Store values in BookController
    this.selectedCategoryId.value = selectedCategoryId;
    this.selectedCategoryTitle.value = selectedCategoryTitle;
  }

  void searchFromFirebase1(
      String query, Function(List<BookModel>) onSearchComplete) async {
    try {
      final result = await FirebaseFirestore.instance.collection('Books').get();

      final searchResults = result.docs
          .where((doc) =>
              doc['title'].toLowerCase().contains(query.toLowerCase()) ||
              doc['author'].toLowerCase().contains(query.toLowerCase()))
          .map((e) => BookModel.fromSnapshot(e))
          .toList();

      if (searchResults.isNotEmpty) {
        onSearchComplete(searchResults);
      }
    } catch (e) {
      print("Error during search: $e");
    }
  }

  void clearFields() {
    title.text = '';
    author.text = '';
    description.text = '';
    publisher.text = '';
    edition.text = '';
    pages.text = '';
    wardrobe.text = '';
    shelf.text = '';
    code.text = '';
    imageUrl.value = '';
    pdfUrl.value = '';
  }

  void deleteBook(String bookId) async {
    isPostUploading.value = true;

    try {
      // Get book details including image and PDF URLs
      DocumentSnapshot bookSnapshot =
          await db.collection("Books").doc(bookId).get();

      if (bookSnapshot.exists) {
        var bookData = bookSnapshot.data() as Map<String, dynamic>;

        // Get image and PDF URLs
        String imageUrl = bookData['coverUrl'];
        String pdfUrl = bookData['bookurl'];

        // Delete from Firebase Storage
        await deleteFile(imageUrl);
        await deleteFile(pdfUrl);

        // Delete from "Books" collection
        await db.collection("Books").doc(bookId).delete();

        // Delete from "userBook" collection
        await db
            .collection("userBook")
            .doc(fAuth.currentUser!.uid)
            .collection("Books")
            .doc(bookId)
            .delete();

        // Delete from "BookCategory" collection
        QuerySnapshot querySnapshot = await db
            .collection("BookCategory")
            .where('bookId', isEqualTo: bookId)
            .get();

        querySnapshot.docs.forEach((doc) async {
          await db.collection("BookCategory").doc(doc.id).delete();
        });

        isPostUploading.value = false;

        successMessage("تم حذف الكتاب ", backgroundColor: Colors.red);
        fetchFeaturedBooks();
        fetchRecentBooks();
        getUserBook();
        final BottomNavigationBarController navController = Get.find();

        // Delay state changes to avoid the error
        Future.delayed(Duration.zero, () {
          navController.selectedIndex.value = 0;
          Get.offAll(GNavBar());
        });
      }
    } catch (e) {
      errorMessage("خطأ أثناء حذف الكتاب");
      print("Error deleting book: $e");
      isPostUploading.value = false;
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    if (fileUrl.isNotEmpty) {
      Reference storageReference = FirebaseStorage.instance.refFromURL(fileUrl);

      try {
        await storageReference.delete();
        print("File deleted successfully");
      } catch (e) {
        print("Error deleting file: $e");
      }
    }
  }

  void successMessage(String message, {Color? backgroundColor}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    // Get.snackbar(
    //   title,
    //   message,
    //   backgroundColor: backgroundColor,
    //   colorText: Colors.white, // Customize text color
    //   snackPosition: SnackPosition.TOP, // Customize snack position
    //   titleText: Text(
    //     title,
    //     textAlign: TextAlign.right,
    //     style: TextStyle(fontWeight: FontWeight.bold),
    //   ),
    //   messageText: Text(
    //     message,
    //     textAlign: TextAlign.right,
    //   ),
    // );
  }

  void updateBook(BookModel book) async {
    isPostUploading.value = true;

    // Delete previous image from Firebase Storage
    if (book.coverUrl != imageUrl.value) {
      try {
        FirebaseStorage.instance.refFromURL(book.coverUrl!).delete();
      } catch (e) {
        print("Error deleting previous image: $e");
      }
    }

    // Delete previous PDF from Firebase Storage
    if (book.bookurl != pdfUrl.value) {
      try {
        FirebaseStorage.instance.refFromURL(book.bookurl!).delete();
      } catch (e) {
        print("Error deleting previous PDF: $e");
      }
    }
    var updatedBook = BookModel(
      id: book.id,
      title: title.text,
      author: author.text,
      description: description.text,
      publisher: publisher.text,
      edition: edition.text,
      pages: int.parse(pages.text),
      categoryId: selectedCategoryId.value,
      subCategoryId: selectedPavillonId.value,
      pavilion: selectedPavillonTitle.value,
      category: selectedCategoryTitle.value,
      wardrobe: int.parse(wardrobe.text),
      shelf: int.parse(shelf.text),
      code: int.parse(code.text),
      coverUrl: imageUrl.value,
      bookurl: pdfUrl.value,
      isFavorite: book.isFavorite,
      createdAt: book.createdAt,
      modifiedAt: Timestamp.fromDate(
          DateTime.now()), // Convert server timestamp to Timestamp
    );

    // Update book in "Books" collection
    await db.collection("Books").doc(book.id).update(updatedBook.toJson());

    // Update book in "userBook" collection
    await db
        .collection("userBook")
        .doc(fAuth.currentUser!.uid)
        .collection("Books")
        .doc(book.id)
        .update(updatedBook.toJson());

    isPostUploading.value = false;

    title.clear();
    author.clear();
    description.clear();
    publisher.clear();
    edition.clear();
    pages.clear();
    selectedPavillonId.value = "";
    selectedPavillonTitle.value = "";
    selectedCategoryId.value = "";
    selectedCategoryTitle.value = '';
    wardrobe.clear();
    shelf.clear();
    code.clear();
    imageUrl.value = "";
    pdfUrl.value = "";

    successMessage("تم تحديث معلومات الكتاب", backgroundColor: Colors.green);
    fetchFeaturedBooks();
    fetchRecentBooks();
    getUserBook();
    Get.to(
      GNavBar(),
      transition: Transition.fadeIn, // Choose your desired transition effect
      duration: Duration(seconds: 1), // Adjust duration as needed
    );
  }

//Function to toggle the favorite status of a book
  //Function to toggle the favorite status of a book
  void toggleFavorite(BookModel book) async {
    try {
      // Check if the book document exists in the 'Books' collection
      DocumentSnapshot? bookSnapshot =
          await db.collection("Books").doc(book.id).get();

      if (bookSnapshot.exists) {
        // Retrieve the isFavorite field from Firestore
        bool isFavoriteFirestore =
            (bookSnapshot.data() as Map<String, dynamic>)['isFavorite'] ??
                false;

        // Toggle the favorite status based on the Firestore data
        if (isFavoriteFirestore) {
          // Remove the book from the user's favorites
          currentUserBooksFavorie.remove(book);
          successMessage("تمت إزالة الكتاب من المفضلة",
              backgroundColor: Colors.red);

          // Remove the book from the user's favorites collection in Firestore
          await db
              .collection("usersFavoriteBooks")
              .doc(fAuth.currentUser!.uid)
              .collection("Favorites")
              .doc(book.id)
              .delete();
          fetchFavoriteBooks();
        } else {
          // Add the book to the user's favorites
          currentUserBooksFavorie.add(book);
          successMessage("تمت إضافة الكتاب إلى المفضلة",
              backgroundColor: Colors.green);

          // Add the book to the user's favorites collection in Firestore
          await db
              .collection("usersFavoriteBooks")
              .doc(fAuth.currentUser!.uid)
              .collection("Favorites")
              .doc(book.id)
              .set({'isFavorite': true});
          fetchFavoriteBooks();
        }

        // Update the 'isFavorite' field in the book's document in Firestore
        await db.collection("Books").doc(book.id).update({
          'isFavorite': !isFavoriteFirestore, // Toggle the favorite status
        });

        // Update the isFavorite property in the BookModel
        book.isFavorite = !isFavoriteFirestore;

        // Notify listeners about the change
        currentUserBooksFavorie.refresh();
      } else {
        print(
            "Error: Book document not found in 'Books' collection. Book ID: ${book.id}");
        // Handle the case where the book document doesn't exist.
        // You might want to log an error, show a message, or handle it appropriately.
      }
    } catch (e) {
      print("Error during toggleFavorite: $e");
      // Handle other exceptions if necessary
    }
  }

  // Fetch only favorite books from Firestore
  Future<void> fetchFavoriteBooks() async {
    try {
      // Show Loader While loading favorite books
      isloading.value = true;

      // Check if the user is logged in
      if (fAuth.currentUser != null) {
        // Fetch books from the 'Books' collection where isFavorite is true
        final booksSnapshot = await db
            .collection('Books')
            .where('isFavorite', isEqualTo: true)
            .get();

        // Convert the snapshot to a list of BookModel
        final favoriteBooks = booksSnapshot.docs.map((doc) {
          final book = BookModel.fromSnapshot(doc);
          print('Fetched book: $book');
          return book;
        }).toList();
        // Assign favorite books
        currentUserBooksFavorie.assignAll(favoriteBooks);
      }
    } catch (e) {
      print('Error fetching favorite books: $e');
    } finally {
      isloading.value = false;
    }
  }
}
