import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uqba_elibrary/components/custom_text_form_field.dart';
import 'package:uqba_elibrary/config/colors.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/view/widget/book/operator/custom_dropdownmenu.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BookController bookController = Get.put(BookController());
    String? selectedPavillon = '0';
    String? selectedCategory = '0';
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF0EACF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.r),
                      bottomRight: Radius.circular(100.r),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "إضافة كتاب جديد",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Iconsax.arrow_left,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                bookController.pickImage();
                              },
                              child: Obx(
                                () => Container(
                                  height: 200,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                  child: Center(
                                    child: bookController.isImageUploading.value
                                        ? CircularProgressIndicator(
                                            color: Color(0xFF573720),
                                          )
                                        : bookController.imageUrl.value == ""
                                            ? Icon(
                                                Icons.add_photo_alternate,
                                                color: Colors.black,
                                                size: 40,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  bookController.imageUrl.value,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFF0EACF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: bookController.isPdfUploading.value
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: backgroudColor,
                                        ),
                                      )
                                    : bookController.pdfUrl.value == ""
                                        ? InkWell(
                                            onTap: () {
                                              bookController.pickPDF();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "رفع كتاب (صيغة PDF)",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ), // Corrected text style
                                                SizedBox(width: 10),
                                                Icon(Icons.upload_file),
                                              ],
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              bookController.pdfUrl.value = "";
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    (bookController.BookName
                                                                .isNotEmpty
                                                            ? "${bookController.BookName}"
                                                            : "") +
                                                        " (PDF)",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.delete,
                                                  size: 25,
                                                ),
                                              ],
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "عنوان الكتاب",
                        icon: Icons.book,
                        controller: bookController.title,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "المؤلف",
                        icon: Icons.person,
                        controller: bookController.author,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "وصف الكتاب",
                        icon: Icons.description,
                        controller: bookController.description,
                        maxLines: 5,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "الناشر",
                        icon: Icons.home,
                        controller: bookController.publisher,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "الطبعة",
                        isNumber: true,
                        icon: Icons.edit,
                        controller: bookController.edition,
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "عدد الصفحات",
                        isNumber: true,
                        icon: Icons.numbers,
                        controller: bookController.pages,
                      ),
                      SizedBox(height: 20),
                      CustomDropDownMenu(
                        text: 'اختر الجناح',
                        stream: FirebaseFirestore.instance
                            .collection('Categories')
                            .orderBy("title", descending: false)
                            .where('categoryId', isEqualTo: null)
                            .snapshots(),
                        selectedValue: selectedPavillon,
                        onChanged: (selectedPavillonId) async {
                          var snapshot = await FirebaseFirestore.instance
                              .collection('Categories')
                              .doc(selectedPavillonId)
                              .get();

                          var selectedPavillonTitle = snapshot.data()!['title'];

                          BookController.instance.updatePavillon(
                              selectedPavillonId!, selectedPavillonTitle);
                        },
                      ),
                      SizedBox(height: 20),
                      CustomDropDownMenu(
                        text: 'اختر القسم',
                        stream: FirebaseFirestore.instance
                            .collection('Categories')
                            .orderBy("title", descending: false)
                            .where('categoryId', isNotEqualTo: null)
                            .snapshots(),
                        selectedValue: selectedCategory,
                        onChanged: (selectedCategoryId) async {
                          var snapshot = await FirebaseFirestore.instance
                              .collection('Categories')
                              .doc(selectedCategoryId)
                              .get();

                          if (snapshot.exists &&
                              snapshot.data() != null &&
                              snapshot.data()!.containsKey('title')) {
                            var selectedCategoryTitle =
                                snapshot.data()!['title'];

                            BookController.instance.updateCategory(
                                selectedCategoryId!, selectedCategoryTitle);
                          } else {
                            print(
                                'Document not found or does not contain the expected data.');
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: "رقم الخزانة",
                        isNumber: true,
                        icon: Icons.numbers,
                        controller: bookController.wardrobe,
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: "رقم الرف",
                        isNumber: true,
                        icon: Icons.shelves,
                        controller: bookController.shelf,
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: "رمز الكتاب",
                        isNumber: true,
                        icon: Icons.code,
                        controller: bookController.code,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                bookController.clearFields();
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.red, // Changed background color
                                  borderRadius: BorderRadius.circular(
                                      15), // Increased border radius
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.red, // Changed border color
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "تفريغ الحقول",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Colors
                                                .white, // Changed text color
                                            fontWeight: FontWeight
                                                .bold, // Added font weight
                                          ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.clear_all,
                                      color: Colors.white, // Changed icon color
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Obx(
                              () => Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.green, // Changed background color
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: bookController.isPdfUploading.value
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          bookController.createBook();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "نشر الكتاب",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    color: Colors
                                                        .white, // Changed text color
                                                    fontWeight: FontWeight
                                                        .bold, // Added font weight
                                                  ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.post_add,
                                              color: Colors
                                                  .white, // Changed icon color
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
