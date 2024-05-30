import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        // color: Color(0xFF15202B),
        // color: Color(0xFFFFF0EACF),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 163, 128, 100),
            Color.fromARGB(255, 122, 103, 91),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100.r),
          bottomRight: Radius.circular(100.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 140.r, // Adjust the radius as per your requirement
              backgroundImage: AssetImage("assets/logo_foreground.png"),
            ),
            SizedBox(height: 40.h),
            Text(
              "المكتبة الرقمية عقبة بن نافع",
              style: TextStyle(
                  fontSize: 62.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20.h),
            Text(
              "المجمع الوقفي الإسلامي زاوية الشيخ بلعموري ",
              style: TextStyle(fontSize: 50.sp, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
