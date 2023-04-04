import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.graduationCap,
              size: 20,
            ),
            label: 'Topic'),
        BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.bolt,
              size: 20,
            ),
            label: 'About'),
        BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.user,
              size: 20,
            ),
            label: 'Profile')
      ],
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.black.withOpacity(0.5),
      onTap: (value) {
        switch (value) {
          case 0:
            break;
          case 1:
            Navigator.pushNamed(context, 'about');
            break;
          case 2:
            Navigator.pushNamed(context, 'profile');
            break;
        }
      },
    );
  }
}
