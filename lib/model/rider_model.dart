import 'package:cloud_firestore/cloud_firestore.dart';

class RiderModel {
  final String uid;
  final String email;
  final String cnic;
  final String phone;
  final String name;
  final String? licenseUrl; // Optional field for the rider's license document
  final String role;
  final DateTime createdAt;

  RiderModel({
    required this.uid,
    required this.email,
    required this.cnic,
    required this.phone,
    required this.name,
    this.licenseUrl, // Nullable
    required this.role,
    required this.createdAt,
  });

  // Convert Firestore data to RiderModel
  factory RiderModel.fromFirestore(Map<String, dynamic> data, String id) {
    try {
      return RiderModel(
        uid: id,
        email: data['email'] ?? '',
        cnic: data['cnic'] ?? '',
        phone: data['phone'] ?? '',
        name: data['name'] ?? '',
        licenseUrl: data['licenseUrl'], // Nullable field
        role: data['role'] ?? 'rider', // Default role is 'rider'
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      throw Exception('Error parsing RiderModel: $e');
    }
  }

  // Convert RiderModel to Firestore-compatible format
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'cnic': cnic,
      'phone': phone,
      'name': name,
      'licenseUrl': licenseUrl, // Include if available
      'role': role,
      'createdAt': createdAt,
    };
  }
}
