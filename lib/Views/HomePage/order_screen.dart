import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/cart_controller.dart';
import 'package:restaurant_management_system/colors.dart';

class OrdersScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    // Fetch orders when the screen builds for the first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.fetchOrders();
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 30.h),
            SizedBox(width: 8.w),
            const Text('Orders'),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.secondaryColor,
        onRefresh: () async {
          await cartController.fetchOrders();
        },
        child: Obx(() {
          if (cartController.isLoadingOrders.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (cartController.orders.isEmpty) {
            return Center(
              child: Text(
                'No orders found.',
                style: TextStyle(
                  fontSize: isMobile ? 16.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 32.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile
                          ? 1
                          : 2, // Single column on mobile, two on web
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio:
                          isMobile ? 0.8 : 1.2, // Adjust card ratio
                    ),
                    itemCount: cartController.orders.length,
                    itemBuilder: (context, index) {
                      final order = cartController.orders[index];
                      final List<dynamic> products = order['products'] ?? [];
                      final Timestamp? createdAt =
                          order['created_at'] as Timestamp?;
                      final DateTime date =
                          createdAt?.toDate() ?? DateTime.now();

                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Carousel
                            if (products.isEmpty)
                              Center(
                                child: Text(
                                  'No products in this order.',
                                  style: TextStyle(
                                    fontSize: isMobile ? 14.sp : 16.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              )
                            else
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: isMobile ? 150.h : 200.h,
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 0.8,
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
                            SizedBox(height: 16.h),

                            // Order Details
                            Text(
                              'Total Price: \$${order['total_price']?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                fontSize: isMobile ? 16.h : 18.h,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'Date: ${date.toLocal()}',
                              style: TextStyle(
                                fontSize: isMobile ? 14.h : 16.h,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Order Status Row
                            _OrderStatusRow(status: order['status'] ?? ''),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        }),
      ),
    );
  }
}

class _OrderStatusRow extends StatelessWidget {
  final String status;

  const _OrderStatusRow({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = ['PLACED', 'PROCESSING', 'DELIVERED', 'CANCELED'];
    final currentIndex = steps.indexOf(status.toUpperCase());

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: steps.map((step) {
          final stepIndex = steps.indexOf(step);
          return Row(
            children: [
              Icon(
                stepIndex <= currentIndex
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: stepIndex <= currentIndex ? Colors.green : Colors.grey,
              ),
              SizedBox(width: 8.w),
              Text(
                step,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: stepIndex <= currentIndex
                      ? Colors.green[800]
                      : Colors.grey[600],
                ),
              ),
              if (step != steps.last)
                Container(
                  width: 30.w,
                  height: 2.h,
                  color: stepIndex < currentIndex ? Colors.green : Colors.grey,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
