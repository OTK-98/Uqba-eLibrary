import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uqba_elibrary/components/book_card.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/view/screen/book/view/book_details.dart';
import 'package:uqba_elibrary/view/screen/gnav_bar.dart';

// ignore: must_be_immutable
class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({Key? key}) : super(key: key);
  BookController bookController = Get.find<BookController>();
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    await bookController.fetchFavoriteBooks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          // backgroundColor: Color(0xFF15202B),
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Iconsax.search_normal,
                          )),
                      Text(
                        " المفضلة",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      IconButton(
                        icon: Icon(
                          Iconsax.arrow_left,
                        ),
                        onPressed: () {
                          Get.to(GNavBar());
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: bookController.currentUserBooksFavorie.isEmpty
                      ? Center(
                          child: Text(
                            "أضف كتبك المفضلة هنا واستمتع بالقراءة",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 0.55, // Adjust this value
                          crossAxisSpacing:
                              1, // Adjust the spacing between columns
                          mainAxisSpacing: 1, // Adjust the spacing between rows
                          padding: EdgeInsets.all(16.0),
                          children: List.generate(
                            bookController.currentUserBooksFavorie.length,
                            (index) {
                              final book =
                                  bookController.currentUserBooksFavorie[index];
                              return BookCard(
                                title: book.title ?? "",
                                coverUrl: book.coverUrl ?? "",
                                ontap: () {
                                  Get.to(BookDetailsScreen(
                                    book: book,
                                  ));
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
