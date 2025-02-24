import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid; // Unique user ID
  final String name;
  final String email;
  // final String? profilePicture; // Optional
  final String role; // Role (e.g., "customer", "supplier", "rider")
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    // this.profilePicture,
    required this.role,
    required this.createdAt,
  });

  // Convert Firestore data to UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      // profilePicture: data['profilePicture'],
      role: data['role'] ?? 'customer', // Default role is 'customer'
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert UserModel to Firestore-compatible format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      // 'profilePicture': profilePicture,
      'role': role,
      'createdAt': createdAt,
    };
  }
}
