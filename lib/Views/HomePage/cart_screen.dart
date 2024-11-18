import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8),
            const Text('Cart')
          ],
        ),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return ListTile(
                      leading: Image.network(item['product_imageURL'],
                          width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(item['product_name']),
                      subtitle: Text('£${item['product_price'].toString()}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
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
                          Text('${item['quantity']}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cartController.updateItemQuantity(
                                  item['product_id'], item['quantity'] + 1);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cartController.removeFromCart(item['product_id']);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Display Total Amount
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Obx(() => Text(
                          'Total: £${cartController.totalAmount.value.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        // Trigger order placing logic
                        cartController.placeOrder();
                      },
                      child: const Text('Place Order'),
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
