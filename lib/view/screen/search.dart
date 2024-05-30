import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uqba_elibrary/components/book_card.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/view/screen/book/view/book_details.dart';
import 'package:uqba_elibrary/view/widget/home/custom_search_textfield.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  BookController bookController = Get.put(BookController());
  bool _isResultsVisible = false;
  List filteredResults = [];
  FocusNode _searchFocusNode = FocusNode(); // Add this line

  void clearSearch() {
    _searchController.clear();
    setState(() {
      _isResultsVisible = false;
      filteredResults.clear();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                CustomSearchTextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  iconButtonLeft: Iconsax.search_normal,
                  onPressed: clearSearch,
                  onChanged: (query) {
                    _searchController.text = query;

                    if (query.isEmpty) {
                      setState(() {
                        _isResultsVisible = false;
                      });
                    } else {
                      bookController.searchFromFirebase1(query,
                          (List<dynamic> searchResults) {
                        setState(() {
                          filteredResults = searchResults;
                          _isResultsVisible = true;
                        });
                      });
                    }
                  },
                  iconButtonRight: Icons.clear,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    child: _isResultsVisible
                        ? GridView.count(
                            scrollDirection: Axis.vertical,
                            crossAxisCount: 3,
                            crossAxisSpacing: 0.1,
                            childAspectRatio: 0.5,
                            children: filteredResults.map((e) {
                              return BookCard(
                                title: e.title,
                                coverUrl: e.coverUrl,
                                ontap: () {
                                  Get.to(BookDetailsScreen(
                                    book: e,
                                  ));
                                },
                              );
                            }).toList(),
                          )
                        : Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              child: Image.asset(
                                "assets/icons/search.png",
                                color: Color(0xFFB3B09D),
                              ),
                            ),
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
