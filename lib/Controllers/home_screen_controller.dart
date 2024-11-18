import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Models/product_model.dart';
import '../models/user_model.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var hotItems = <ProductModel>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;
  var categoryItems = <ProductModel>[].obs;
  var allItems = <ProductModel>[].obs;
  var searchQuery = ''.obs;
  var username = ''.obs;
  var useremail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchAllItems();
    fetchHotItems();
    var userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    fetchUserData(userId);
  }

  // Fetching random "hot" items
  Future<void> fetchHotItems() async {
    try {
      if (allItems.isEmpty) {
        await fetchAllItems();
      }
      // Select random items for hot items (up to 5)
      List<ProductModel> randomItems = List.from(allItems);
      randomItems.shuffle(Random());
      hotItems.value = randomItems.take(5).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching hot items: $e');
      }
    }
  }

  // Fetching unique categories
  Future<void> fetchCategories() async {
    try {
      var snapshot = await _firestore.collection('products').get();

      // Extract unique categories
      categories.value = snapshot.docs
          .map((doc) => doc.data()['category'] as String)
          .toSet()
          .toList();

      if (categories.isNotEmpty) {
        selectedCategory.value = categories.first;
        fetchCategoryItems(categories.first);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching categories: $e');
      }
    }
  }

  // Fetching all items across categories
  Future<void> fetchAllItems() async {
    try {
      var snapshot = await _firestore.collection('products').get();

      allItems.value = snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all items: $e');
      }
    }
  }

  // Fetching items for a specific category
  Future<void> fetchCategoryItems(String category) async {
    try {
      selectedCategory.value = category;

      var snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      categoryItems.value = snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching category items: $e');
      }
    }
  }

  // Filtering items based on search query
  void filterItems(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      fetchCategoryItems(selectedCategory.value);
    } else {
      categoryItems.value = allItems
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Function to fetch user data
  Future<void> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        UserModel user =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        username.value = user.name ?? 'Guest';
        useremail.value = user.email ?? 'abc@gmail.com';
      } else {
        username.value = 'Guest';
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
      username.value = 'Guest';
    }
  }
}
