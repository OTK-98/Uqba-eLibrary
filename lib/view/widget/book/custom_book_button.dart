import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/models/book_model.dart';
import 'package:uqba_elibrary/view/screen/book/view/book_view.dart';

// ignore: must_be_immutable
class CustomBookButton extends StatefulWidget {
  final String bookUrl;
  final String bookName;
  bool? isFavorite; // Change type to bool
  String id; // Add this line to accept the id parameter.

  CustomBookButton({
    Key? key,
    required this.bookUrl,
    required this.bookName,
    this.isFavorite, // Update type
    required this.id,
  }) : super(key: key);

  @override
  State<CustomBookButton> createState() => _CustomBookButtonState();
}

class _CustomBookButtonState extends State<CustomBookButton> {
  @override
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    BookController bookController = Get.find(); // Change to Get.find()
    BookModel book = Get.put(BookModel(id: widget.id));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.bookUrl.isNotEmpty) {
                  Get.to(BookView(
                    bookUrl: widget.bookUrl,
                    bookName: widget.bookName,
                  ));
                } else {
                  Fluttertoast.showToast(
                    msg: "لم يتم رفع الكتاب بعد!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFFFF81746B),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF573720),
                ),
                child: Text(
                  "إبدأ القراءة",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              bookController.toggleFavorite(book);
              setState(() {
                widget.isFavorite = widget.isFavorite == true
                    ? false
                    : true; // Assign boolean value directly
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).primaryColor,
                border: Border.all(
                  color: Color(0xFFDAD7CE),
                ),
              ),
              child: widget.isFavorite == true
                  ? Icon(
                      Icons.bookmark_add,
                      color: Color(0xFF573720),
                    )
                  : Icon(
                      Icons.bookmark_add_outlined,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
  // widget.isFavorite == true
  //                     ? Icons.bookmark_add_outlined
  //                     : Icons.bookmark_add,
  //                 color: widget.isFavorite == true
  //                     ? Color(0xFF573720)
  //                     : Colors.grey),