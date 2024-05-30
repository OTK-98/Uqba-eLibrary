import 'package:flutter/material.dart';
import 'package:uqba_elibrary/controller/bottom_nav_bar_controller.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final BottomNavigationBarController controller;

  CustomBottomNavigationBarItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = controller.selectedIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.selectedIndex.value = index;
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: isSelected ? 50 : 50,
          width: isSelected ? 40 : 30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: isSelected ? Colors.blue : Colors.grey,
                  size: isSelected ? 25 : 20),
              SizedBox(height: 4.0),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey,
                  fontSize: isSelected ? 14 : 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
