import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/models/category_model.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  // Variables
  RxString selectedCategory = ''.obs; // Add this line

  final _db = FirebaseFirestore.instance;

  // Get All Categories
  Stream<List<CategoryModel>> getAllCategories() {
    try {
      return _db
          .collection('Categories')
          .orderBy("title", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((document) => CategoryModel.fromSnapshot(document))
              .toList());
    } catch (e) {
      throw 'حدث خطأ ما، حاول مرة أخرى';
    }
  }

  // Get SubCategories

  Future<List<CategoryModel>> getSubCategory(String categoryId) async {
    try {
      final snapshot = await _db
          .collection("Categories")
          .orderBy("title", descending: false)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      final result =
          snapshot.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();

      return result;
    } catch (e) {
      print('Error fetching subcategories: $e');
      throw 'An error occurred, please try again';
    }
  }
}
