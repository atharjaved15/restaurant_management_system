import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Models/product_model.dart';
import 'package:restaurant_management_system/colors.dart';
import 'package:restaurant_management_system/controllers/cart_controller.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  final CartController cartController = Get.put(CartController());

  ProductDetailsScreen({super.key, required this.product});

  RxInt quantity = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Ensure the logo path is correct
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text('Product Details'),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 250,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product Name
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Product Price
              Text(
                '£${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              // Product Description
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              // Quantity Control
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity.value > 1) {
                        quantity.value--;
                      }
                    },
                  ),
                  Obx(() => Text(
                        '${quantity.value}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      quantity.value++;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Add to Cart Button
              ElevatedButton(
                onPressed: () {
                  cartController.addToCart(product, quantity.value);
                  Get.snackbar(
                    'Added to Cart',
                    '${product.name} x${quantity.value} added to cart',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.secondaryColor,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
