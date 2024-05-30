import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uqba_elibrary/components/book_tile_vertical.dart';
import 'package:uqba_elibrary/controller/category_controller.dart';
import 'package:uqba_elibrary/models/book_model.dart';
import 'package:uqba_elibrary/models/category_model.dart';
import 'package:uqba_elibrary/view/screen/book/view/book_details.dart';
import 'package:uqba_elibrary/view/widget/home/sub_pavillon_body.dart';

class SubPavillonScreen extends StatelessWidget {
  final CategoryModel category;

  SubPavillonScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            category.title!,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Iconsax.arrow_left,
              ),
              onPressed: () {
                // Assuming 'book' is the current BookModel instance
                Get.back();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "الأقسام",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<List<CategoryModel>>(
                      future: categoryController.getSubCategories(category.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text(
                                  'لا يحتوي هذا الجناح على أي أقسام بعد!'));
                        } else {
                          final subCategories = snapshot.data!;

                          return ValueListenableBuilder<int?>(
                            valueListenable:
                                categoryController.selectedSubCategory,
                            builder: (context, selectedSubCategory, _) {
                              return SubPavillonBody(
                                subCategories,
                                categoryController.selectedSubCategory,
                                (index) {
                                  selectedSubCategory = index;
                                  categoryController.getCategoriesBooks(
                                    categoryId: subCategories[index].id!,
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "جميع الكتب",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // ValueListenableBuilder for books
                      ValueListenableBuilder<int?>(
                        valueListenable: categoryController.selectedSubCategory,
                        builder: (context, selectedSubCategory, _) {
                          int? currentSelectedSubCategory = selectedSubCategory;

                          Future<List<BookModel>> fetchBooks() async {
                            if (currentSelectedSubCategory != null) {
                              final subCategories = await categoryController
                                  .getSubCategories(category.id!);
                              print(
                                  'Selected Subcategory ID: ${subCategories[currentSelectedSubCategory].id!}');
                              final books =
                                  await categoryController.getCategoriesBooks(
                                categoryId:
                                    subCategories[currentSelectedSubCategory]
                                        .id!,
                              );
                              print('Fetched books for subcategory: $books');
                              return books;
                            } else {
                              // Fetch books for the main category when no subcategory is selected
                              print(
                                  'No Subcategory selected, fetching books for the main category');
                              final books = await categoryController
                                  .getCategoriesBooks(categoryId: category.id!);
                              print('Fetched books for main category: $books');
                              return books;
                            }
                          }

                          return FutureBuilder<List<BookModel>>(
                            future: fetchBooks(),
                            builder: (context,
                                AsyncSnapshot<List<BookModel>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                print('Fetching books, please wait...');
                                return CircularProgressIndicator();
                              }

                              if (snapshot.hasError) {
                                print(
                                    'Error fetching books: ${snapshot.error}');
                                return Text('لم يتم العثور على أي كتاب');
                              }

                              final books = snapshot.data;
                              print('Number of books: ${books?.length}');

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 0.7,
                                  childAspectRatio: 0.2,
                                ),
                                itemCount: books?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final book = books![index];
                                  return BookTileVertical(
                                    ontap: () {
                                      Get.to(BookDetailsScreen(book: book));
                                    },
                                    title: book.title!,
                                    coverUrl: book.coverUrl!,
                                    author: book.author!,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
