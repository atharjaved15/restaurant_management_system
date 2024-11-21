import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/Staff%20Controllers/staff_controller.dart';
import 'package:restaurant_management_system/Views/Staff/my_orders.dart';
import 'package:restaurant_management_system/Views/Staff/orders_screen.dart';
import 'package:restaurant_management_system/Views/Staff/profile_screen.dart';
import 'package:restaurant_management_system/Views/Staff/staff_dashboard.dart';
import 'package:restaurant_management_system/colors.dart';

class StaffHomePageStructure extends StatelessWidget {
  final StaffController controller = Get.put(StaffController());

  final List<Widget> screens = [
    StaffDashboardScreen(),
    StaffOrderScreen(),
    MyOrdersScreen(),
    StaffProfileScreen(),
    // DashboardScreen(),
    // NewOrdersScreen(),
    // MyOrdersScreen(),
    // ProfileScreen(),
  ];

  StaffHomePageStructure({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen width is wide enough to be considered a web view

        return Obx(() => Scaffold(
              body: IndexedStack(
                index: controller.currentIndex.value,
                children: screens,
              ),
              // Conditionally display the BottomNavigationBar only for narrow screens
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: (index) => controller.changeTabIndex(index),
                type: BottomNavigationBarType.fixed,
                selectedItemColor:
                    AppColors.accentColor, // Adjust the color as needed
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.new_releases),
                    label: 'New Orders',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment_turned_in),
                    label: 'My Orders',
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
