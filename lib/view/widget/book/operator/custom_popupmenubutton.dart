import 'package:flutter/material.dart';

class CustomPopUpMenuButton extends StatelessWidget {
  final void Function()? onPressedEdit;
  final void Function()? onPressedDelete;
  final IconData icon;

  const CustomPopUpMenuButton({
    Key? key,
    this.onPressedEdit,
    this.onPressedDelete,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(icon),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue), // Edit icon
              SizedBox(width: 10),
              Text('تعديل', style: TextStyle(color: Colors.blue)), // Edit text
            ],
          ),
          value: 'edit',
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red), // Delete icon
              SizedBox(width: 10),
              Text('حذف', style: TextStyle(color: Colors.red)), // Delete text
            ],
          ),
          value: 'delete',
        ),
      ],
      onSelected: (String value) {
        if (value == 'edit') {
          onPressedEdit?.call();
        } else if (value == 'delete') {
          onPressedDelete?.call();
        }
      },
    );
  }
}
