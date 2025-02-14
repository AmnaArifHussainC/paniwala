import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  final String uid;
  final String email;
  final String cnic;
  final String phone;
  final String companyName;
  final String role;
  final DateTime createdAt;
  final String? certificateUrl;

  SupplierModel({
    required this.uid,
    required this.email,
    required this.cnic,
    required this.phone,
    required this.companyName,
    required this.role,
    required this.createdAt,
    this.certificateUrl,
  });

  factory SupplierModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SupplierModel(
      uid: id,
      email: data['email'] ?? '',
      cnic: data['cnic'] ?? '',
      phone: data['phone'] ?? '',
      companyName: data['company_name'] ?? '',
      role: data['role'] ?? 'supplier',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      certificateUrl: data['certificateUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'cnic': cnic,
      'phone': phone,
      'company_name': companyName,
      'role': role,
      'createdAt': createdAt,
      if (certificateUrl != null) 'certificateUrl': certificateUrl,
    };
  }
}
