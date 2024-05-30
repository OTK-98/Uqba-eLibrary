import 'package:flutter/material.dart';

import '../config/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String btnName;
  final VoidCallback ontap;
  const PrimaryButton({super.key, required this.btnName, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: ontap,
        child: Container(
          width: double.infinity,
          height: 55,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                btnName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.background,
                      letterSpacing: 1.5,
                    ),
              ),
              SizedBox(width: 20),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: backgroudColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset("Assets/Icons/google.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
