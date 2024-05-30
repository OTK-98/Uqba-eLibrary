import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';
import 'package:uqba_elibrary/view/widget/welcome/bottom_section.dart';
import 'package:uqba_elibrary/view/widget/welcome/middle_section.dart';
import 'package:uqba_elibrary/view/widget/welcome/top_section.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    LoginController authController = Get.put(LoginController());

    return Scaffold(
      // backgroundColor: Color(0xFF15202B),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: LayoutBuilder(builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TopSection(),
              MiddleSection(),
              BottomSection(authController: authController),
            ],
          );
        }),
      ),
    );
  }
}
