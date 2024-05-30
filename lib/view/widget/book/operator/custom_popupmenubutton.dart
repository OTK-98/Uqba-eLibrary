import 'package:flutter/material.dart';

class CustomPopUpMenuButton extends StatelessWidget {
  final void Function()? onPresseEdit;
  final void Function()? onPressdDelete;

  const CustomPopUpMenuButton({
    Key? key,
    this.onPresseEdit,
    this.onPressdDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(
        Icons.more_horiz,
      ),
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
          onPresseEdit?.call();
        } else if (value == 'delete') {
          onPressdDelete?.call();
        }
      },
    );
  }
}
