import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management_system/controllers/cart_controller.dart';

class OrdersScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    // Call fetchOrders on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.fetchOrders();
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8),
            const Text('Orders'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await cartController.fetchOrders();
        },
        child: Obx(() {
          if (cartController.isLoadingOrders.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (cartController.orders.isEmpty) {
            return const Center(
              child: Text('No orders found.'),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 32.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      isMobile ? 1 : 2, // Single column on mobile, two on web
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: isMobile ? 0.8 : 1.2, // Adjust card ratio
                ),
                itemCount: cartController.orders.length,
                itemBuilder: (context, index) {
                  final order = cartController.orders[index];
                  final List<dynamic> products = order['products'] ?? [];
                  final Timestamp? createdAt =
                      order['created_at'] as Timestamp?;
                  final DateTime date = createdAt?.toDate() ?? DateTime.now();

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    color: Colors.grey[100],
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Display
                          if (products.isEmpty)
                            const Center(
                              child: Text('No products in this order.'),
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
                              fontSize: isMobile ? 16.sp : 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          Text(
                            'Date: ${date.toLocal()}',
                            style: TextStyle(
                                fontSize: isMobile ? 14.sp : 16.sp,
                                color: Colors.grey),
                          ),
                          SizedBox(height: 8.h),

                          // Collapsible Status Widget
                          _OrderStatusCollapsible(
                              status: order['status'] ?? ''),
                        ],
                      ),
                    ),
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

class _OrderStatusCollapsible extends StatefulWidget {
  final String status;

  const _OrderStatusCollapsible({required this.status});

  @override
  State<_OrderStatusCollapsible> createState() =>
      _OrderStatusCollapsibleState();
}

class _OrderStatusCollapsibleState extends State<_OrderStatusCollapsible> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final steps = ['PLACED', 'PROCESSING', 'DELIVERED', 'CANCELED'];
    final currentIndex = steps.indexOf(widget.status.toUpperCase());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(_isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
            ],
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                for (int i = 0; i < steps.length; i++)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      i <= currentIndex
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: i <= currentIndex ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      steps[i],
                      style: TextStyle(
                        color: i <= currentIndex
                            ? Colors.green[800]
                            : Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
