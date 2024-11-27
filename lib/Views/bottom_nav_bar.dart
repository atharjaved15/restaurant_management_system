import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/home_screen_controller.dart';
import 'package:restaurant_management_system/Views/HomePage/cart_screen.dart';
import 'package:restaurant_management_system/Views/HomePage/home_screen.dart';
import 'package:restaurant_management_system/Views/HomePage/order_screen.dart';
import 'package:restaurant_management_system/Views/HomePage/profile_screen.dart';
import 'package:restaurant_management_system/colors.dart';

class BottomNavMobile extends StatefulWidget {
  const BottomNavMobile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavMobileState createState() => _BottomNavMobileState();
}

class _BottomNavMobileState extends State<BottomNavMobile> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    OrdersScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
