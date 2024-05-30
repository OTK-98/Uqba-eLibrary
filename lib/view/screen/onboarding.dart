import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uqba_elibrary/data/datasource/static/onboarding_data.dart';
import 'package:uqba_elibrary/view/widget/onboarding/onboarding_button.dart';
import 'package:uqba_elibrary/view/widget/onboarding/onboarding_dots.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoardingScreen> {
  final onBoardingData = OnBoardingData();
  final pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: Container(
            // color: Color(0xFF15202B), // Set the background color here
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                      itemCount: onBoardingData.items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 60.h),
                          child: Card(
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0.r),
                            ),
                            elevation: 5,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.asset(
                                      onBoardingData.items[index].image,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 80.h),
                                  Text(
                                    onBoardingData.items[index].title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 64.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 40.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25.w),
                                    child: Text(
                                      onBoardingData.items[index].Description,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 50.sp,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                OnBoardingDots(currentIndex: currentIndex),
                SizedBox(height: 20),
                OnBoardingButton(
                  onBoardingController: onBoardingData,
                  pageController: pageController,
                  currentIndex: currentIndex,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
