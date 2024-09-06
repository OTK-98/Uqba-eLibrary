import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/view/screen/gnav_bar.dart';
import 'package:uqba_elibrary/view/screen/welcome.dart';

import '../Config/Messages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAuthorizedUser = false.obs;
  BookController bookController = Get.put(BookController());
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Firestore instance

  @override
  void onInit() {
    super.onInit();
    checkAuthorizationStatus();
    bookController.fetchFeaturedBooks();
    bookController.fetchRecentBooks();
    bookController.fetchFavoriteBooks();
    bookController.getUserBook();
  }

  Future<void> checkAuthorizationStatus() async {
    String? currentUserEmail = auth.currentUser?.email;
    if (currentUserEmail != null) {
      QuerySnapshot snapshot = await firestore
          .collection('adminUsers')
          .where('email', isEqualTo: currentUserEmail)
          .limit(1)
          .get();
      isAuthorizedUser.value = snapshot.docs.isNotEmpty;
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
      await checkAuthorizationStatus(); // Check authorization status after login
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
