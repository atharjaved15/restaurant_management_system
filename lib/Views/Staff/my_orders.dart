import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management_system/Controllers/Staff%20Controllers/staff_controller.dart';

class MyOrdersScreen extends StatelessWidget {
  final StaffController staffController = Get.find();

  MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Fetch orders on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      staffController.fetchMyOrders();
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 24.h),
            SizedBox(width: 8.w),
            Text(
              'My Orders',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await staffController.fetchMyOrders();
        },
        child: Obx(() {
          if (staffController.isLoadingOrders.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (staffController.myOrders.isEmpty) {
            return Center(
              child: Text(
                'No orders found.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.w : 32.w,
                vertical: 16.h,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                mainAxisExtent: isMobile ? 360.h : 400.h,
              ),
              itemCount: staffController.myOrders.length,
              itemBuilder: (context, index) {
                final order = staffController.myOrders[index];
                return _OrderCard(
                  order: order,
                  isMobile: isMobile,
                  onStatusChange: () =>
                      staffController.updateOrderStatus(order),
                );
              },
            );
          }
        }),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isMobile;
  final VoidCallback onStatusChange;

  const _OrderCard({
    required this.order,
    required this.isMobile,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> products = order['products'] ?? [];
    final Timestamp? createdAt = order['created_at'] as Timestamp?;
    final DateTime date = createdAt?.toDate() ?? DateTime.now();
    final String status = order['status'] ?? 'PLACED';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Carousel or Single Image
            if (products.isEmpty)
              Center(
                child: Text(
                  'No products in this order.',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              )
            else if (products.length == 1)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    products[0]['product_imageURL'],
                    width: double.infinity,
                    height: isMobile ? 150.h : 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              CarouselSlider(
                options: CarouselOptions(
                  height: isMobile ? 150.h : 200.h,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: products.map((product) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      product['product_imageURL'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 12.h),

            // Order Details
            Text(
              'Total Price: \$${order['total_price']?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Date: ${date.toLocal()}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 12.h),

            // Order Status and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: $status',
                  style: TextStyle(
                    fontSize: 16,
                    color: status == 'DELIVERED'
                        ? Colors.green
                        : (status == 'CANCELED' ? Colors.red : Colors.amber),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (status != 'DELIVERED' && status != 'CANCELED')
                  ElevatedButton(
                    onPressed: onStatusChange,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      'Next Status',
                      style: TextStyle(fontSize: 12.sp),
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
