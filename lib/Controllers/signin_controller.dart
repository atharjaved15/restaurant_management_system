import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  Future<void> uploadProductsToFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Load the JSON file from assets
      String jsonString = await rootBundle.loadString('assets/food_items.json');
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Iterate over each category and its products
      for (String category in jsonData['categories'].keys) {
        List<dynamic> products = jsonData['categories'][category];

        for (var product in products) {
          // Add the category field to each product
          product['category'] = category;

          // Upload each product as a document in the "products" collection
          await firestore.collection('products').add(product);
        }
      }

      print('Products uploaded successfully');
    } catch (e) {
      print('Error uploading products: $e');
    }
  }

  Future<void> signIn(String email, String password, String role) async {
    isLoading.value = true;

    // await uploadProductsToFirestore();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        String firestoreRole = (userDoc['role'] as String).trim().toLowerCase();
        String selectedRole = role.trim().toLowerCase();

        if (firestoreRole == selectedRole) {
          Get.snackbar(
            'Success',
            'Logged in successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          if (role == 'User') {
            Get.offAllNamed('/main');
          } else if (role == 'Staff') {
            Get.offAllNamed('/staffHome');
          }
        } else {
          Get.snackbar(
            'Role Mismatch',
            'Selected role does not match your account role',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'User document not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
