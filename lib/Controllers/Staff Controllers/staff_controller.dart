import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Models/staff_model.dart';

class StaffController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStaffDetails();
    fetchOrders(); // Fetch the staff details when the controller is initialized
  }

  // Update the selected tab index
  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> myOrders = <Map<String, dynamic>>[].obs;
  RxBool isLoadingOrders = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var currentStaff = Rxn<Staff>();

  Future<void> fetchOrders() async {
    isLoadingOrders.value = true;
    try {
      // Listen to real-time changes in the 'orders' collection for the logged-in user
      _firestore.collection('orders').snapshots().listen((snapshot) {
        // This will be triggered whenever the data changes in Firestore
        orders.assignAll(snapshot.docs.map((doc) {
          return {
            'order_id': doc.id,
            ...doc.data(),
          };
        }).toList());

        if (orders.isEmpty) {
          debugPrint('No orders found for user:');
        } else {
          debugPrint('Fetched orders: ${orders.length}');
        }
      });
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      Get.snackbar('Error', 'Failed to fetch orders');
    } finally {
      isLoadingOrders.value = false;
    }
  }

  void updateOrderStatus(Map<String, dynamic> order) async {
    try {
      final String orderId = order['order_id'];
      final String currentStatus = order['status'];
      final String nextStatus = _getNextStatus(currentStatus);

      if (nextStatus.isEmpty) return;

      await _firestore.collection('orders').doc(orderId).update({
        'status': nextStatus,
        if (nextStatus == 'PROCESSING') 'pickedBy': currentStaff.value!.uid,
      });

      if (nextStatus == 'DELIVERED') {
        await _updateUserStats(order);
      }

      Get.snackbar('Success', 'Order status updated to $nextStatus');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status: $e');
    }
  }

  Future<void> fetchMyOrders() async {
    isLoadingOrders.value = true;
    try {
      // Replace 'currentUserId' with the actual ID of the logged-in user
      final String currentUserId = currentStaff.value!.uid;

      // Listen to real-time changes in the 'orders' collection
      _firestore.collection('orders').snapshots().listen((snapshot) {
        // Filter orders where 'pickedBy' matches the current user's ID
        final filteredOrders = snapshot.docs.where((doc) {
          final data = doc.data();
          // Check if 'pickedBy' exists and matches the current user's ID
          return data.containsKey('pickedBy') &&
              data['pickedBy'] == currentUserId;
        }).map((doc) {
          // Map the filtered orders into the desired structure
          return {
            'order_id': doc.id,
            ...doc.data(),
          };
        }).toList();

        // Update myOrders with the filtered data
        myOrders.assignAll(filteredOrders);

        if (myOrders.isEmpty) {
          debugPrint('No orders found for user: $currentUserId');
        } else {
          debugPrint('Fetched orders: ${myOrders.length}');
        }
      });
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      Get.snackbar('Error', 'Failed to fetch orders');
    } finally {
      isLoadingOrders.value = false;
    }
  }

  Future<void> _updateUserStats(Map<String, dynamic> order) async {
    try {
      // Fetch the order amount
      final double orderAmount = (order['total_price'] ?? 0.0).toDouble();

      // Reference to the current user's document
      final DocumentReference userRef =
          _firestore.collection('users').doc(currentStaff.value!.uid);

      // Fetch the user data
      final userSnapshot = await userRef.get();
      if (!userSnapshot.exists) {
        debugPrint("User document does not exist.");
        return;
      }

      // Retrieve user data safely
      final userData = userSnapshot.data() as Map<String, dynamic>;
      final double currentAmountEarned =
          (userData['amountEarned'] ?? 0.0).toDouble();
      final double currentCommissionEarned =
          (userData['profit'] ?? 0.0).toDouble();
      final int ordersCompleted = (userData['ordersCompleted'] ?? 0).toInt();

      // Calculate updated values
      final double updatedAmountEarned = currentAmountEarned + orderAmount;
      final double updatedCommissionEarned =
          currentCommissionEarned + (orderAmount * 0.2);
      final int updatedOrdersCompleted = ordersCompleted + 1;

      // Update the fields in Firestore
      await userRef.update({
        'amountEarned': updatedAmountEarned,
        'profit': updatedCommissionEarned,
        'ordersCompleted': updatedOrdersCompleted,
      });

      debugPrint(
          "User stats updated successfully: AmountEarned = $updatedAmountEarned, Profit = $updatedCommissionEarned, OrdersCompleted = $updatedOrdersCompleted.");
    } catch (e) {
      debugPrint("Error updating user stats: $e");
      Get.snackbar("Error", "Failed to update user stats");
    }
  }

  String _getNextStatus(String currentStatus) {
    const steps = ['PLACED', 'PROCESSING', 'DELIVERED', 'CANCELED'];
    final currentIndex = steps.indexOf(currentStatus.toUpperCase());

    if (currentIndex == -1 || currentIndex >= steps.length - 1) return '';
    return steps[currentIndex + 1];
  }

  // Fetch the current signed-in staff member's data
  Future<void> fetchStaffDetails() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          // Convert the document data to a map and create a Staff instance
          currentStaff.value =
              Staff.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching staff data: $e");
      }
    }
  }
}
