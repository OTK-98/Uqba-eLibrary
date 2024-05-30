import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiddleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.6,
      decoration: BoxDecoration(
        // color: Color.fromARGB(255, 13, 21, 27),
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(100.r),
          topRight: Radius.circular(100.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "نبذة عن تطبيقنا",
              style: TextStyle(fontSize: 62.sp, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 8,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.r),
              ),
              // color: Color(0xFF15202B), // Set the background color here
              color: Theme.of(context).colorScheme.primary,

              margin: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 50.sp, color: Colors.black, height: 1.8),
                    children: [
                      TextSpan(
                        text:
                            "تطبيق المكتبة الرقمية الوقفية عقبة بن نافع يهدف إلى تعزيز تجربة القراءة وإدارة الموارد في المكتبة من خلال توفير:\n",
                      ),
                      TextSpan(
                        text: "١. اكتشاف ومطالعة أحدث الكتب؛\n",
                      ),
                      TextSpan(
                        text: "٢. خاصية البحث الفعال؛\n",
                      ),
                      TextSpan(
                        text: "٣. إدارة الحسابات الشخصية؛\n",
                      ),
                      TextSpan(
                        text: "٤. تصفح الأجنحة والأقسام؛\n",
                      ),
                      TextSpan(
                        text: "٥.الوصول السريع للمكتبة من قبل المستخدمين؛",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
