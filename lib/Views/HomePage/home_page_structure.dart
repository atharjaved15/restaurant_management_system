import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/nav_controller.dart';
import 'package:restaurant_management_system/Views/HomePage/order_screen.dart';
import 'package:restaurant_management_system/colors.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> screens = [
    HomeScreen(),
    OrdersScreen(),
    CartScreen(),
    const ProfileScreen(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen width is wide enough to be considered a web view
        final bool isWideScreen = constraints.maxWidth > 600;

        return Obx(() => Scaffold(
              body: IndexedStack(
                index: controller.currentIndex.value,
                children: screens,
              ),
              // Conditionally display the BottomNavigationBar only for narrow screens
              bottomNavigationBar: isWideScreen
                  ? null
                  : BottomNavigationBar(
                      currentIndex: controller.currentIndex.value,
                      onTap: (index) => controller.changeTabIndex(index),
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: AppColors.secondaryColor,
                      unselectedItemColor: AppColors.textColor,
                      showUnselectedLabels: true,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.list_alt),
                          label: 'Orders',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart),
                          label: 'Cart',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'Profile',
                        ),
                      ],
                    ),
            ));
      },
    );
  }
}
