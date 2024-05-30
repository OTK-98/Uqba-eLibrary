import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/models/book_model.dart';
import 'package:uqba_elibrary/view/widget/book/custom_book_button.dart';
import 'package:uqba_elibrary/view/widget/book/custom_book_header.dart';

// ignore: must_be_immutable
class BookDetailsScreen extends StatelessWidget {
  final BookModel book;

  BookDetailsScreen({super.key, required this.book});
  BookController bookController = Get.put(BookController());

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    await bookController.fetchFeaturedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    // color: Color(0xFF15202B),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomBookHeader(
                            id: book.id,
                            coverUrl: book.coverUrl!,
                            title: book.title!,
                            author: book.author!,
                            description: book.description!,
                            publisher: book.publisher!,
                            edition: book.edition!,
                            pages: book.pages.toString(),
                            pavillon: book.pavilion.toString(),
                            category: book.category.toString(),
                            wardrobe: book.wardrobe.toString(),
                            shelf: book.shelf.toString(),
                            code: book.code.toString(),
                            isFavorite: book.isFavorite.toString(),
                            book: book,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        CustomBookButton(
                          bookUrl: book.bookurl!,
                          bookName: book.title!,
                          id: book.id,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
