import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String id;
  String? categoryId;
  String? subCategoryId;
  String? title;
  String? author;
  String? description;
  String? publisher;
  String? edition;
  int? code;
  int? pages;
  int? wardrobe;
  int? shelf;
  String? bookurl;
  String? pavilion;
  String? category;
  String? coverUrl;
  bool? isFavorite;
  Timestamp? createdAt;
  Timestamp? modifiedAt;

  BookModel({
    required this.id,
    this.categoryId,
    this.subCategoryId,
    this.title,
    this.author,
    this.description,
    this.publisher,
    this.edition,
    this.pages,
    this.wardrobe,
    this.shelf,
    this.code,
    this.bookurl,
    this.pavilion,
    this.category,
    this.coverUrl,
    this.isFavorite,
    this.createdAt,
    this.modifiedAt,
  });

  // Create Empty function for clean code
  static BookModel empty() => BookModel(
        id: '',
        title: '',
        author: '',
        description: '',
        publisher: '',
        edition: '',
        code: 0,
        pages: 0,
        wardrobe: 0,
        shelf: 0,
      );

  // To json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["categoryId"] = categoryId;
    _data["subCategoryId"] = subCategoryId;
    _data["title"] = title;
    _data["author"] = author;
    _data["description"] = description;
    _data["publisher"] = publisher;
    _data["edition"] = edition;
    _data["pages"] = pages;
    _data["wardrobe"] = wardrobe;
    _data["shelf"] = shelf;
    _data["code"] = code;
    _data["bookurl"] = bookurl;
    _data["pavilion"] = pavilion;
    _data["category"] = category;
    _data["coverUrl"] = coverUrl;
    _data["isFavorite"] = isFavorite;
    _data["createdAt"] = createdAt;
    _data["modifiedAt"] = modifiedAt;

    return _data;
  }

  // From snapshot
  factory BookModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return BookModel.empty();
    final data = document.data()!;
    return BookModel(
      id: document.id,
      categoryId: data["categoryId"] ?? '',
      subCategoryId: data["subCategoryId"] ?? '',
      title: data["title"] ?? '',
      author: data["author"] ?? '',
      description: data["description"] ?? '',
      publisher: data["publisher"] ?? '',
      edition: data["edition"] ?? '',
      pages: data["pages"] ?? 0,
      wardrobe: data["wardrobe"] ?? 0,
      shelf: data["shelf"] ?? 0,
      code: data["code"] ?? 0,
      category: data["category"] ?? '',
      pavilion: data["pavilion"] ?? '',
      bookurl: data["bookurl"] ?? '',
      coverUrl: data["coverUrl"] ?? '',
      isFavorite: data["isFavorite"] ?? false,
      createdAt: data["createdAt"],
      modifiedAt: data["modifiedAt"],
    );
  }
}
