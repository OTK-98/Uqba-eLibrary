import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/view/screen/onboarding.dart';

import '../view/screen/gnav_bar.dart';

class SplashController extends GetxController {
  final auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    splashController();
  }

  void splashController() {
    Future.delayed(Duration(seconds: 4), () {
      if (auth.currentUser != null) {
        Get.offAll(GNavBar());

        // Get.offAll(BottomNavigationBar());
      } else {
        Get.offAll(OnBoardingScreen());
      }
    });
  }
}
