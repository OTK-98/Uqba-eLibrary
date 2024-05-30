import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/models/book_model.dart';

class BookRepository extends GetxController {
  static BookRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<BookModel>> getFeaturedBooks() async {
    try {
      final snapshot = await _db.collection('Books').get();

      return snapshot.docs
          .map((document) => BookModel.fromSnapshot(document))
          .toList();
    } catch (e) {
      throw 'حدث خطأ ما، حاول مرة أخرى';
    }
  }

  Future<List<BookModel>> getRecentBooks() async {
    try {
      final snapshot = await _db
          .collection('Books')
          .orderBy("createdAt", descending: true)
          .limit(3)
          .get();

      return snapshot.docs
          .map((document) => BookModel.fromSnapshot(document))
          .toList();
    } catch (e) {
      throw 'حدث خطأ ما، حاول مرة أخرى';
    }
  }

  // Get Books for Category

  Future<List<BookModel>> getBooksForCategory(
      {required String categoryId}) async {
    try {
      if (categoryId.isEmpty) {
        // Handle the case where categoryId is empty
        return [];
      }
      // Query to get all documents where bookId match the provided categoryId
      QuerySnapshot bookCategoryQuery = await _db
          .collection('BookCategory')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      // Extract Books from the documents
      List<String> booksIds =
          bookCategoryQuery.docs.map((doc) => doc['bookId'] as String).toList();

      if (booksIds.isEmpty) {
        // Handle the case where there are no books for the given category
        return [];
      }

      //  Query to get all documents where bookId match the provided categoryId
      final booksQuery = await _db
          .collection('Books')
          .where(FieldPath.documentId, whereIn: booksIds)
          .get();

      List<BookModel> books =
          booksQuery.docs.map((doc) => BookModel.fromSnapshot(doc)).toList();
      // print('Fetched Books: $books');

      return books;
    } catch (e) {
      throw 'حدث خطأ ما، حاول مرة أخرى';
    }
  }

  // Get Books for Category

  Future<List<BookModel>> getBooksForSubCategory(
      {required String categoryId}) async {
    try {
      // Query to get all documents where categoryId matches the provided categoryId
      QuerySnapshot booksQuery = await _db
          .collection('Books')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      // Extract Books from the documents
      List<BookModel> books = booksQuery.docs
          .map((QueryDocumentSnapshot<Object?> doc) => BookModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      return books;
    } catch (e) {
      print('Error in getBooksForSubCategory: $e');
      throw 'حدث خطأ ما، حاول مرة أخرى';
    }
  }
}
