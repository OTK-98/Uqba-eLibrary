import 'package:cloud_firestore/cloud_firestore.dart';

class BookCategoryModel {
  final String categoryId;
  final String bookId;

  BookCategoryModel({
    required this.categoryId,
    required this.bookId,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'bookId': bookId,
    };
  }

  factory BookCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BookCategoryModel(
      categoryId: data['categoryId'] as String,
      bookId: data['bookId'] as String,
    );
  }
}
