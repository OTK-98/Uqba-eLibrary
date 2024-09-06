import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uqba_elibrary/components/book_tile_horizontal.dart';
import 'package:uqba_elibrary/components/book_tile_vertical.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/controller/bottom_nav_bar_controller.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';
import 'package:uqba_elibrary/view/screen/book/operator/add_book.dart';
import 'package:uqba_elibrary/view/screen/book/view/book_details.dart';
import 'package:uqba_elibrary/view/widget/home/custom_appbar.dart';
import 'package:uqba_elibrary/view/widget/home/custom_search_textfield.dart';
import 'package:uqba_elibrary/view/widget/home/pavillon.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final BookController bookController = Get.put(BookController());
  final LoginController authController = Get.put(LoginController());

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    await bookController.fetchFeaturedBooks();
    await bookController.fetchRecentBooks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      children: [
                        const CustomAppBar(),
                        const SizedBox(height: 30),
                        CustomSearchTextField(
                          iconButtonLeft: Iconsax.search_normal,
                          onTap: () {
                            Get.find<BottomNavigationBarController>()
                                .selectedIndex
                                .value = 2;
                          },
                        ),
                        const SizedBox(height: 10),
                        Pavillon(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20, left: 0, bottom: 5, top: 5),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "الأحدث",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF433A31),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            if (bookController.isloading.value)
                              return const CircularProgressIndicator();

                            if (bookController.featuredBooks().isEmpty) {
                              return Center(
                                child: Text(
                                  'لم يتم العثور على أي كتب',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(color: Colors.black),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: bookController.recentBooks
                                    .map(
                                      (e) => BookTileVertical(
                                        ontap: () {
                                          Get.to(BookDetailsScreen(book: e));
                                        },
                                        title: e.title!,
                                        coverUrl: e.coverUrl!,
                                        author: e.author!,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          }),
                          Row(
                            children: [
                              Text(
                                "جميع الكتب",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF433A31),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            if (bookController.isloading.value)
                              return const CircularProgressIndicator();

                            if (bookController.featuredBooks().isEmpty) {
                              return Center(
                                child: Text(
                                  'لم يتم العثور على أي كتب',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(color: Colors.black),
                                ),
                              );
                            }
                            return Column(
                              children: bookController.featuredBooks
                                  .map(
                                    (e) => BookTileHorizontal(
                                      ontap: () {
                                        Get.to(BookDetailsScreen(book: e));
                                      },
                                      title: e.title!,
                                      coverUrl: e.coverUrl!,
                                      author: e.author!,
                                      publisher: e.publisher!,
                                      edition: e.edition!,
                                      pavillon: e.pavilion!,
                                    ),
                                  )
                                  .toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Obx(() {
            if (authController.isAuthorizedUser.value) {
              return FloatingActionButton(
                onPressed: () {
                  Get.to(AddBookScreen());
                },
                child: Icon(
                  Icons.add,
                  color: Color(0xFF573720),
                ),
              );
            } else {
              return SizedBox.shrink(); // or return Container();
            }
          }),
        ),
      ),
    );
  }
}
