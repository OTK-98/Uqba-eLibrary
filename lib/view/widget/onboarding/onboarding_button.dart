import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/data/datasource/static/onboarding_data.dart';
import 'package:uqba_elibrary/view/screen/welcome.dart';

class OnBoardingButton extends StatelessWidget {
  final OnBoardingData onBoardingController;
  final PageController pageController;
  final int currentIndex;
  const OnBoardingButton({
    Key? key,
    required this.onBoardingController,
    required this.pageController,
    required this.currentIndex,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40.h),
      height: 55,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        gradient: LinearGradient(
          colors: [
            Color(0xFF573720),
            Color.fromARGB(255, 141, 99, 69),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: TextButton(
        onPressed: () {
          if (currentIndex != onBoardingController.items.length - 1) {
            pageController.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            Get.to(WelcomeScreen());
          }
        },
        child: Text(
          currentIndex == onBoardingController.items.length - 1
              ? "لنبدأ"
              : "تابع",
          style: TextStyle(
              color: Colors.white,
              fontSize: 62.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
