import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/home_screen_controller.dart';
import 'package:restaurant_management_system/Views/HomePage/cart_screen.dart';
import 'package:restaurant_management_system/Views/HomePage/home_screen.dart';
import 'package:restaurant_management_system/Views/HomePage/order_screen.dart';
import 'package:restaurant_management_system/Views/HomePage/profile_screen.dart';
import 'package:restaurant_management_system/colors.dart';

class SideNavWeb extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<Widget> _screens = [
    HomeScreen(),
    OrdersScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  SideNavWeb(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: onItemTapped,
          backgroundColor: AppColors.backgroundColor,
          selectedIconTheme: const IconThemeData(color: AppColors.primaryColor),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.list),
              label: Text('Orders'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.shopping_cart),
              label: Text('Cart'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person),
              label: Text('Profile'),
            ),
          ],
        ),
        // Expanded area for main content
        Expanded(child: _screens[selectedIndex]),
      ],
    );
  }
}
