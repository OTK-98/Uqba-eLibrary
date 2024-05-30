import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uqba_elibrary/controller/bottom_nav_bar_controller.dart';

class GNavBar extends StatelessWidget {
  const GNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarController navController =
        Get.put(BottomNavigationBarController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 2,
              right: 2,
              bottom: 2,
              top: 2,
            ),
            child: GNav(
              tabBorderRadius: 100,
              backgroundColor: Color(0xFFE7E1D1),
              color: Colors.black,
              activeColor: Colors.white,
              tabBackgroundColor: Color(0xFF573720),
              padding: const EdgeInsets.all(10),
              gap: 8,
              tabs: [
                GButton(
                  icon: Iconsax.home,
                  text: 'الصفحة الرئيسة',
                ),
                GButton(
                  icon: Iconsax.gallery,
                  text: 'معرض الصور',
                ),
                GButton(
                  icon: Iconsax.search_favorite,
                  text: 'البحث',
                ),
                GButton(
                  icon: Iconsax.heart,
                  text: 'المفضلة',
                ),
                GButton(
                  icon: Iconsax.user,
                  text: 'حسابي',
                ),
              ],
              onTabChange: (index) {
                navController.selectedIndex.value = index;
              },
            ),
          ),
        ),
        body:
            Obx(() => navController.screens[navController.selectedIndex.value]),
      ),
    );
  }
}
