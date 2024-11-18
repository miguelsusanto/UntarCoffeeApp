import 'package:flutter/material.dart';
import 'home_page.dart';
import 'account_page.dart';

class CustomFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomFooter({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Color(0xFFAF251C),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
    );
  }
}
