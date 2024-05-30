import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';

class BottomSection extends StatelessWidget {
  final LoginController authController;

  const BottomSection({required this.authController});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        authController.loginWithEmail();
      },
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.1,
        decoration: BoxDecoration(
          // color: Color.fromARGB(255, 13, 21, 27),
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
          child: Container(
            decoration: BoxDecoration(
              // color: Color(0xFFFFF0EACF),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 77, 57, 43),
                  Color.fromARGB(255, 141, 99, 69),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "تسجيل الدخول باستخدام جوجل",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 2.sp,
                      fontSize: 60.sp),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Image.asset("assets/icons/google.png"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
