import 'package:assignment_flutter_app/app/bottomnav/cart.dart';
import 'package:assignment_flutter_app/app/bottomnav/homepage.dart';
import 'package:assignment_flutter_app/app/bottomnav/profile_screen.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNav extends StatefulWidget {
  int currentIndex;
  BottomNav({
    required this.currentIndex,
    super.key,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  List<Widget> get pages => [
        const HomeScreen(),
        const CartScreen(),
        const ProfileScreen(),
      ];

  void _onItemTapped(int index) async {
    if (index >= 0 && index < pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        unselectedItemColor: const Color.fromRGBO(208, 208, 208, 1),
        selectedItemColor: const Color.fromRGBO(54, 57, 91, 1),
        selectedFontSize: 13,
        unselectedFontSize: 10,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(243, 245, 247, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home_outlined,
              size: 25,
              color: MyColors.green,
            ),
            icon: const Icon(
              Icons.home_outlined,
              size: 20,
              color: Color.fromRGBO(147, 147, 147, 1),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.shopping_cart_outlined,
              size: 25,
              color: MyColors.green,
            ),
            icon: const Icon(
              Icons.shopping_cart_outlined,
              size: 20,
              color: Color.fromRGBO(147, 147, 147, 1),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person_2_outlined,
              color: MyColors.green,
              size: 25,
            ),
            icon: const Icon(
              Icons.person_2_outlined,
              color: Color.fromRGBO(147, 147, 147, 1),
              size: 20,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
