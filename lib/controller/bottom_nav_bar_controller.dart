import 'package:get/get.dart';
import 'package:uqba_elibrary/view/screen/favorite.dart';
import 'package:uqba_elibrary/view/screen/gallery.dart';
import 'package:uqba_elibrary/view/screen/home.dart';
import 'package:uqba_elibrary/view/screen/profile.dart';
import 'package:uqba_elibrary/view/screen/search.dart';

class BottomNavigationBarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    GalleryScreen(),
    SearchScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];
  @override
  void onInit() {
    super.onInit();
    ever(selectedIndex, (index) {
      print("Navigation index changed to $index");
    });
  }
}
