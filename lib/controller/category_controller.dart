import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/data/Repositories/books/book_repository.dart';
import 'package:uqba_elibrary/data/Repositories/categories/category_repository.dart';
import 'package:uqba_elibrary/models/book_model.dart';
import 'package:uqba_elibrary/models/category_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isloading = false.obs;
  String? selectedCategory = '0';
  ValueNotifier<int?> selectedSubCategory = ValueNotifier<int?>(null);

  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  RxList<BookModel> affiliatedBooks = <BookModel>[].obs;

  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// load category data
  Future<void> fetchCategories() async {
    try {
      // Show Loader While loading categories
      isloading.value = true;

      // Listen to real-time updates for categories from data source (Firebase)
      _categoryRepository.getAllCategories().listen((categories) {
        // Update the categories list
        allCategories.assignAll(categories);

        // Filter featured categories
        featuredCategories.assignAll(allCategories
            .where((category) => category.catgId!.isEmpty)
            .toList());
      });
    } catch (e) {
      print('Oh, Snap $e');
    } finally {
      isloading.value = false;
    }
  }

  /// load selected category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final subCategories =
          await _categoryRepository.getSubCategory(categoryId);

      return subCategories;
    } catch (e) {
      'Oh, Snap ${e}';
      return [];
    }
  }

  /// Get Category or Sub-Category Books
  Future<List<BookModel>> getCategoriesBooks(
      {required String categoryId}) async {
    try {
      final books = await BookRepository.instance
          .getBooksForSubCategory(categoryId: categoryId);
      print('Fetched books for categoryId: $categoryId');
      return books;
    } catch (e) {
      print('Error in getCategoriesBooks: $e');
      throw 'حدث خطأ ما، حاول مرة أخرى';
    }
  }
}
