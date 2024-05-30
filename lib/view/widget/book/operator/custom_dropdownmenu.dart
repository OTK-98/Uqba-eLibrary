import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDropDownMenu extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final String? selectedValue;
  final String? text;
  final ValueChanged<String?> onChanged;

  const CustomDropDownMenu({
    Key? key,
    required this.stream,
    required this.selectedValue,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          List<DropdownMenuItem<String>> items = [];

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            final categories = snapshot.data?.docs.reversed.toList();

            items.add(DropdownMenuItem(value: "0", child: Text(text!)));

            for (var category in categories!) {
              items.add(DropdownMenuItem(
                value: category.id,
                child: Text(category['title']),
              ));
            }
          }

          return DropdownButtonFormField<String>(
            items: items,
            onChanged: onChanged,
            value: selectedValue,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              hintStyle: TextStyle(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
