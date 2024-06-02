import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/controller/bottom_nav_bar_controller.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';
import 'package:uqba_elibrary/models/book_model.dart';
import 'package:uqba_elibrary/view/screen/book/operator/edit_book.dart';
import 'package:uqba_elibrary/view/screen/gnav_bar.dart';
import 'package:uqba_elibrary/view/screen/home.dart';
import 'package:uqba_elibrary/view/widget/book/operator/custom_popupmenubutton.dart';

class CustomBookHeader extends StatelessWidget {
  final BookModel book;

  final String id;
  final String coverUrl;
  final String title;
  final String author;
  final String description;
  final String publisher;
  final String edition;
  final String pages;
  final String pavillon;
  final String category;
  final String wardrobe;
  final String shelf;
  final String code;
  final String isFavorite;

  CustomBookHeader({
    Key? key,
    required this.id,
    required this.coverUrl,
    required this.title,
    required this.author,
    required this.description,
    required this.publisher,
    required this.edition,
    required this.pages,
    required this.pavillon,
    required this.category,
    required this.wardrobe,
    required this.shelf,
    required this.code,
    required this.isFavorite,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final LoginController authController = Get.find<LoginController>();
    final BookController bookController = Get.find<BookController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              authController.isAuthorizedUser.value
                  ? CustomPopUpMenuButton(
                      icon: Icons.more_horiz,
                      onPressedEdit: () {
                        Get.to(
                          EditBookScreen(
                            book: book, // Pass the book details
                          ),
                        );
                      },
                      onPressedDelete: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              title: Text(
                                "!تأكيد الحذف",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors.red, // Custom color for the title
                                ),
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                "هل أنت متأكد أنك تريد حذف الكتاب؟",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors
                                      .black, // Custom color for the content
                                ),
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        bookController.deleteBook(book.id);
                                      },
                                      child: Text("تأكيد"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.grey[
                                            300], // Custom text color for Cancel button
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("إلغاء"),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  : SizedBox(), // If not authorized user, show an empty SizedBox
              Text(
                "تفاصيل الكتاب",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
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
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            "المؤلف : $author",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 20),
          ExpansionTile(
            childrenPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            expansionAnimationStyle: AnimationStyle(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              reverseCurve: Curves.easeInOut,
            ),
            dense: true,
            title: Text(
              "تفاصيل إضافية",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            iconColor: Colors.black,
            children: [
              _buildDetailItem("اسم الجناح", pavillon),
              _buildDetailItem("اسم القسم", category),
              _buildDetailItem("دار النشر", publisher),
              _buildDetailItem("الطبعة", edition),
              _buildDetailItem("رقم الخزانة", wardrobe),
              _buildDetailItem("رقم الرف", shelf),
              _buildDetailItem("عدد الصفحات", pages),
              _buildDetailItem("رمز الكتاب", code),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "وصف الكتاب",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 150,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: ReadMoreText(
                                "${description}",
                                trimLines: 5,
                                textAlign: TextAlign.justify,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '...اقرأ المزيد',
                                trimExpandedText: 'اقرأ اقل',
                                moreStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                lessStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDetailItem(String title, String value) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),

    leading: Icon(Icons.circle, size: 8), // Bullet icon
    title: Text(
      "$title: $value",
      style: TextStyle(fontSize: 14),
    ),
  );
}
