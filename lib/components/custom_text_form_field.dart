import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isNumber;
  final int? maxLines;
  final TextEditingController controller;

  const CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.isNumber = false,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Align(
        alignment: Alignment.topLeft,
        child: TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            filled: true,
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            hintText: hintText,
            hintStyle: TextStyle(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Color(0xFF573720),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Color(0xFF573720),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
