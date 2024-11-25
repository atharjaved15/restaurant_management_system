import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8),
            const Text(
              'Cart',
              style: TextStyle(fontSize: 18), // Adjusted font size
            )
          ],
        ),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18), // Adjusted font size
            ),
          );
        } else {
          return Column(
            children: [
              // List of cart items
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            item['product_imageURL'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            item['product_name'],
                            style: TextStyle(
                              fontSize: screenWidth > 600 ? 18 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '£${item['product_price'].toString()}',
                            style: TextStyle(
                              fontSize: screenWidth > 600 ? 16 : 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: SizedBox(
                            width: screenWidth > 600 ? 150 : 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    int newQuantity = item['quantity'] - 1;
                                    if (newQuantity > 0) {
                                      cartController.updateItemQuantity(
                                          item['product_id'], newQuantity);
                                    } else {
                                      cartController
                                          .removeFromCart(item['product_id']);
                                    }
                                  },
                                ),
                                Text(
                                  '${item['quantity']}',
                                  style: TextStyle(
                                    fontSize: screenWidth > 600 ? 16 : 14,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    cartController.updateItemQuantity(
                                        item['product_id'],
                                        item['quantity'] + 1);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    cartController
                                        .removeFromCart(item['product_id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Display Total Amount
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () => Text(
                        'Total: £${cartController.totalAmount.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: screenWidth > 600 ? 24 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        // Trigger order placing logic
                        cartController.placeOrder();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: screenWidth > 600 ? 20 : 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
