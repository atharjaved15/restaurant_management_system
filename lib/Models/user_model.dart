import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? name;
  final String? phone;
  final String? email;
  final String? role;
  final String? uid;
  final Timestamp? createdAt;

  UserModel({
    this.name,
    this.phone,
    this.email,
    this.role,
    this.uid,
    this.createdAt,
  });

  // Factory constructor to create a UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] as String?,
      phone: data['phone'] as String?,
      email: data['email'] as String?,
      role: data['role'] as String?,
      uid: data['uid'] as String?,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  // Method to convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'uid': uid,
      'createdAt': createdAt,
    };
  }
}
