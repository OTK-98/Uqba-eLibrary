import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';
import 'package:uqba_elibrary/view/widget/home/greetings.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController authController = Get.put(LoginController());

    List<String> nameParts =
        authController.auth.currentUser!.displayName!.split(" ");
    String firstName = nameParts.last;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Greeting(),
              const SizedBox(width: 10),
              Text(
                "$firstName!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                      authController.auth.currentUser!.photoURL!)))
        ],
      ),
    );
  }
}
