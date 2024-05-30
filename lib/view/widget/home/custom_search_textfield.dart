import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSearchTextField extends StatelessWidget {
  void Function()? onTap;
  void Function(String)? onChanged;
  void Function()? onPressed;

  TextEditingController? controller;
  IconData? iconButtonLeft;
  IconData? iconButtonRight;

  final FocusNode? focusNode;

  CustomSearchTextField({
    this.onTap,
    this.onChanged,
    this.onPressed,
    this.controller,
    this.iconButtonLeft,
    this.iconButtonRight,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Icon(
              iconButtonLeft,
              color: Color(0xFFB3B09D),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: TextFormField(
              focusNode: focusNode,
              style: TextStyle(color: Colors.black),
              controller: controller,
              onChanged: onChanged,
              onTap: () {
                focusNode?.requestFocus();
                onTap?.call();
              },
              decoration: const InputDecoration(
                hintText: "ابحث عن كتابك المفضل ..",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: onPressed,
              child: Icon(
                iconButtonRight,
                color: Color(0xFFB3B09D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
