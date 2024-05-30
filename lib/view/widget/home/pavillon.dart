import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/controller/category_controller.dart';
import 'package:uqba_elibrary/view/screen/sub_pavillon.dart';

class Pavillon extends GetView<BookController> {
  const Pavillon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    return Obx(() {
      if (categoryController.isloading.value)
        return const CircularProgressIndicator();

      if (categoryController.featuredCategories.isEmpty) {
        return Center(
          child: Text(
            'لا تحتوي المكتبة على أجنحة بعد',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.black),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 50,
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemCount: categoryController.featuredCategories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = categoryController.featuredCategories[index];
              return InkWell(
                onTap: () {
                  Get.to(() => SubPavillonScreen(
                        category: category,
                      ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface, // Use your preferred background color
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "${category.title}",
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF433A31),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
