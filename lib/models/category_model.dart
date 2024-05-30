import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? id;
  String? title;
  String? catgId;

  CategoryModel({
    required this.id,
    required this.title,
    this.catgId = '',
  });

  static CategoryModel empty() => CategoryModel(id: '', title: '');

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'categoryId': catgId,
    };
  }

  CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      id = document.id;
      title = data["title"] ?? '';
      catgId = data["categoryId"] ?? '';
    } else {
      id = '';
      title = '';
      catgId = '';
    }
  }
}
