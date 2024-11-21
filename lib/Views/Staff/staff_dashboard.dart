import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/Staff%20Controllers/staff_controller.dart';
import 'package:restaurant_management_system/Models/staff_model.dart';
import 'package:restaurant_management_system/colors.dart';

class StaffDashboardScreen extends StatelessWidget {
  final StaffController controller = Get.find();

  StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.currentStaff.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          Staff staff = controller.currentStaff.value!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message with Username
                Text(
                  'Welcome, ${staff.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                const SizedBox(height: 20),

                // The containers for Amount Earned, Orders Completed, Profit Earned
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoCard('Amount Earned',
                        '\$${staff.amountEarned.toStringAsFixed(2)}'),
                    _infoCard('Orders Completed', '${staff.ordersCompleted}'),
                    _infoCard(
                      'Profit Earned',
                      '\$${staff.profit.toStringAsFixed(2)}',
                      prominent: true, // Make this container more prominent
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // "My Orders" Heading
                const Text(
                  'My Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),

                // Display the orders
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.myOrders.length,
                  itemBuilder: (context, index) {
                    return _orderCard(controller.myOrders[index]);
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Info Card widget for Amount Earned, Orders Completed, Profit Earned
  Widget _infoCard(String title, String value, {bool prominent = false}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: prominent ? AppColors.accentColor : AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      width: (Get.width - 48) / 3, // Adjust the width based on screen size
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Order Card widget
  Widget _orderCard(Map<String, dynamic> order) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Order Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                order['image']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),

            // Order Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['productName']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Status: ${order['orderStatus']}',
                  style: TextStyle(
                    color: order['orderStatus'] == 'Completed'
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Price: ${order['price']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
