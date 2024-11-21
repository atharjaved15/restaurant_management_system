import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  // Method for signing up the user
  Future<void> signup(String name, String phone, String email, String password,
      String role) async {
    isLoading.value = true;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data in Firestore
      role == 'Staff'
          ? await _firestore
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
              'name': name,
              'phone': phone,
              'email': email,
              'role': role,
              'uid': userCredential.user?.uid,
              'amountEarned': 0,
              'profit': 0,
              'ordersCompleted': 0,
              'createdAt': FieldValue.serverTimestamp(),
            })
          : await _firestore
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
              'name': name,
              'phone': phone,
              'email': email,
              'role': role,
              'uid': userCredential.user?.uid,
              'createdAt': FieldValue.serverTimestamp(),
            });

      Get.snackbar(
        'Success',
        'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(8),
        borderRadius: 10,
      );

      Get.offAllNamed('/login'); // Redirect to home or any other screen
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(8),
        borderRadius: 10,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
