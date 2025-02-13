import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  final String uid;
  final String email;
  final String cnic;
  final String role;
  final String companyName;
  final DateTime createdAt;

  SupplierModel({
    required this.uid,
    required this.email,
    required this.cnic,
    required this.companyName,
    required this.role,
    required this.createdAt,
  });

  // Convert Firestore data to SupplierModel
  factory SupplierModel.fromFirestore(Map<String, dynamic> data, String id) {
    try {
      return SupplierModel(
        uid: id,
        cnic: data['cnic'] ?? '',
        email: data['email'] ?? '',
        companyName: data['company_name'] ?? '',
        role: data['role'] ?? 'Supplier', // Default role is 'Supplier'
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      throw Exception('Error parsing SupplierModel: $e');
    }
  }

  // Convert SupplierModel to Firestore-compatible format
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'company_name': companyName,
      'cnic': cnic,
      'role': role,
      'createdAt': createdAt,
    };
  }
}
