import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  final String name;
  final String phone;
  final String email;
  final String role;
  final String uid;
  final double amountEarned;
  final double profit;
  final int ordersCompleted;
  final Timestamp createdAt;

  Staff({
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.uid,
    required this.amountEarned,
    required this.profit,
    required this.ordersCompleted,
    required this.createdAt,
  });

  // Factory constructor to create a Staff instance from Firestore data
  factory Staff.fromMap(Map<String, dynamic> data) {
    return Staff(
      name: data['name'] as String,
      phone: data['phone'] as String,
      email: data['email'] as String,
      role: data['role'] as String,
      uid: data['uid'] as String,
      amountEarned: (data['amountEarned'] as num).toDouble(),
      profit: (data['profit'] as num).toDouble(),
      ordersCompleted: data['ordersCompleted'] as int,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  // Method to convert Staff instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'uid': uid,
      'amountEarned': amountEarned,
      'profit': profit,
      'ordersCompleted': ordersCompleted,
      'createdAt': createdAt,
    };
  }
}
