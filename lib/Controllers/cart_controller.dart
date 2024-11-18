import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Models/product_model.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoadingOrders = false.obs;

  RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  RxDouble totalAmount = 0.0.obs;
  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  Future<void> updateItemQuantity(String productId, int quantity) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final cartRef = _firestore.collection('cart').doc(user.uid);

        // Retrieve current cart data
        final cartSnapshot = await cartRef.get();
        Map<String, dynamic> cartData = cartSnapshot.data() ?? {};
        List<Map<String, dynamic>> products =
            List<Map<String, dynamic>>.from(cartData['products'] ?? []);

        // Find the product and update its quantity, returning an empty map if not found
        final product = products.firstWhere(
          (item) => item['product_id'] == productId,
          orElse: () => <String, dynamic>{},
        );

        if (product.isNotEmpty) {
          product['quantity'] = quantity;

          // Recalculate total amount
          double total = products.fold(0, (sum, item) {
            return sum + (item['product_price'] * item['quantity']);
          });

          // Update Firestore document
          await cartRef.update({
            'products': products,
            'total_amount': total,
          });

          // Update local observable state
          cartItems.assignAll(products);
          totalAmount.value = total;

          Get.snackbar('Success', 'Item quantity updated');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to update item quantity');
      }
    }
  }

  Future<void> placeOrder() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final cartRef = _firestore.collection('cart').doc(user.uid);

        // Retrieve current cart data
        final cartSnapshot = await cartRef.get();
        Map<String, dynamic> cartData = cartSnapshot.data() ?? {};
        List<Map<String, dynamic>> products =
            List<Map<String, dynamic>>.from(cartData['products'] ?? []);
        double total = cartData['total_amount'] ?? 0.0;

        // Fetch user details
        final userRef = _firestore.collection('users').doc(user.uid);
        final userSnapshot = await userRef.get();
        String username = userSnapshot.data()?['name'] ?? 'Guest';

        // Save the order in Firestore with status as "placed"
        await _firestore.collection('orders').add({
          'user_id': user.uid,
          'user_name': username,
          'products': products,
          'total_price': total,
          'status': 'placed',
          'created_at': DateTime.now(),
        });

        // Clear the cart after placing the order
        await cartRef.delete();

        // Update local observable state
        cartItems.clear();
        totalAmount.value = 0.0;

        Get.snackbar('Success', 'Order placed successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to place order');
      }
    }
  }

  Future<void> fetchOrders() async {
    isLoadingOrders.value = true;
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User is not logged in');
        return;
      }

      final snapshot = await _firestore
          .collection('orders')
          .where('user_id', isEqualTo: user.uid)
          .get();

      // Ensure data is fetched correctly
      orders.assignAll(snapshot.docs.map((doc) {
        return {
          'order_id': doc.id,
          ...doc.data(),
        };
      }).toList());

      if (orders.isEmpty) {
        debugPrint('No orders found for user: ${user.uid}');
      } else {
        debugPrint('Fetched orders: ${orders.length}');
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      Get.snackbar('Error', 'Failed to fetch orders');
    } finally {
      isLoadingOrders.value = false;
    }
  }

  // Add to cart with quantity
  Future<void> addToCart(ProductModel product, int quantity) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final cartRef = _firestore.collection('cart').doc(user.uid);

        // Retrieve current cart data
        final cartSnapshot = await cartRef.get();
        Map<String, dynamic> cartData = cartSnapshot.data() ?? {};
        List<Map<String, dynamic>> products =
            List<Map<String, dynamic>>.from(cartData['products'] ?? []);

        // Check if the product already exists in cart
        final existingProduct = products.firstWhere(
          (item) => item['product_id'] == product.id,
          orElse: () => <String, dynamic>{},
        );

        if (existingProduct.isNotEmpty) {
          // Update quantity if product already exists
          existingProduct['quantity'] += quantity;
        } else {
          // Add new product entry with quantity if it doesn't exist
          products.add({
            'product_id': product.id,
            'product_name': product.name,
            'product_price': product.price,
            'product_imageURL': product.imageUrl,
            'quantity': quantity,
          });
        }

        // Recalculate total amount
        double total = products.fold(0, (sum, item) {
          return sum + (item['product_price'] * item['quantity']);
        });

        // Update Firestore document
        await cartRef.set({
          'products': products,
          'total_amount': total,
          'created_at': cartData['created_at'] ?? DateTime.now(),
          'isOrdered': cartData['isOrdered'] ?? false,
        });

        // Optionally update local observable state if needed
        cartItems.assignAll(products);
        totalAmount.value = total;

        Get.snackbar('Success', 'Item added to cart');
      } catch (e) {
        Get.snackbar('Error', 'Failed to add item to cart');
      }
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String productId) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final cartRef = _firestore.collection('cart').doc(user.uid);

        // Retrieve current cart data
        final cartSnapshot = await cartRef.get();
        Map<String, dynamic> cartData = cartSnapshot.data() ?? {};
        List<Map<String, dynamic>> products =
            List<Map<String, dynamic>>.from(cartData['products'] ?? []);

        // Remove the item based on product_id
        products.removeWhere((item) => item['product_id'] == productId);

        // Calculate new total amount
        double total = products.fold(0, (sum, item) {
          return sum + (item['product_price'] * item['quantity']);
        });

        // Update Firestore document
        await cartRef.update({
          'products': products,
          'total_amount': total,
        });

        // Update local observable state
        cartItems.assignAll(products);
        totalAmount.value = total;

        Get.snackbar('Success', 'Item removed from cart');
      } catch (e) {
        Get.snackbar('Error', 'Failed to remove item from cart');
      }
    }
  }
}
