import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:uqba_elibrary/controller/book_controller.dart';
import 'package:uqba_elibrary/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    Get.put(BookController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Lottie.asset(
            "assets/animation/splash_animataion.json",
          ),
        ),
      ),
    );
  }
}
