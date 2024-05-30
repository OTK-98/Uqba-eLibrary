import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/view/screen/gnav_bar.dart';
import 'package:uqba_elibrary/view/screen/welcome.dart';

import '../Config/Messages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAuthorizedUser = false.obs; // Added this line
  BookController bookController = Get.put(BookController());
  final auth = FirebaseAuth.instance;
  @override
  void onInit() {
    super.onInit();
    checkAuthorizationStatus();
    bookController.fetchFeaturedBooks();
    bookController.fetchRecentBooks();
    bookController.fetchFavoriteBooks();
    bookController.getUserBook();
  }

  void checkAuthorizationStatus() {
    String? currentUserEmail = auth.currentUser?.email;
    if (currentUserEmail != null) {
      isAuthorizedUser.value = currentUserEmail == "kherfham123@gmail.com" ||
          currentUserEmail == "moh2617khaled@gmail.com" ||
          currentUserEmail == "khaled.farid1998@gmail.com" ||
          currentUserEmail == "hbbmoi17@gmail.com";
    } else {
      isAuthorizedUser.value = false;
    }
  }

  void loginWithEmail() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await auth.signInWithCredential(credential);
      successMessage('تسجيل الدخول');
      Get.offAll(GNavBar());

      // Get.offAll(BottomNavigationBar());
    } catch (ex) {
      print(ex);
      errorMessage("حدث خطأ، حاول مجددا!");
    }
    isLoading.value = false;
  }

  void signout() async {
    await auth.signOut();
    successMessage('تسجيل الخروج');
    Get.offAll(const WelcomeScreen());
  }
}
