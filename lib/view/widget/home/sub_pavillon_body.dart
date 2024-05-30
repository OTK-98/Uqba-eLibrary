import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/controller/category_controller.dart';
import 'package:uqba_elibrary/models/category_model.dart';

class SubPavillonBody extends StatelessWidget {
  final List<CategoryModel> subCategories;
  final ValueNotifier<int?> selectedSubCategory;
  final Function(int) onSubCategorySelected; // Add this callback

  SubPavillonBody(
    this.subCategories,
    this.selectedSubCategory,
    this.onSubCategorySelected, // Initialize the callback
  );

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<
        CategoryController>(); // Use Get.find to get the existing instance

    return Obx(() {
      if (categoryController.isloading.value)
        return const CircularProgressIndicator();

      if (categoryController.featuredCategories.isEmpty) {
        return Center(
          child: Text(
            'لم يتم العثور على أي بيانات',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.black),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF15202B),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100.r),
              bottomRight: Radius.circular(100.r),
            ),
          ),
          child: SizedBox(
            height: 50,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final subCategory = subCategories[index];
                return InkWell(
                  onTap: () async {
                    selectedSubCategory.value = index;

                    Text(
                      subCategory.title!,
                      style: TextStyle(color: Colors.black),
                    );
                    print('SubCategoryTitle: ${subCategory.title!}');
                    await categoryController.getCategoriesBooks(
                        categoryId: subCategory.id!);
                    print('SubCategoryId: ${subCategory.id!}');

                    onSubCategorySelected(index);
                    // print('Index: ${index}');
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedSubCategory.value == index
                          ? Color(0xFF573720)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: selectedSubCategory.value == index
                          ? Border.all(
                              color: Color(
                                  0xFF573720), // Change the border color for the selected subcategory
                              width:
                                  2, // Adjust the border width for the selected subcategory
                            )
                          : null, // No border for unselected subcategories
                    ),
                    child: Center(
                      child: Text(
                        "${subCategory.title}",
                        style: TextStyle(
                          fontSize: selectedSubCategory.value == index
                              ? 18 // Adjust the font size for the selected subcategory
                              : 16, // Font size for unselected subcategories
                          color: selectedSubCategory.value == index
                              ? Colors
                                  .white // Text color for the selected subcategory
                              : Colors
                                  .black, // Text color for unselected subcategories
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
