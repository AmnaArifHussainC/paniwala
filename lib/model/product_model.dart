import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductModel {
  final String id;
  final String supplierId; // Supplier ID
  final bool isRefill;
  final String productName;
  final String productDescription;
  final List<String> imageUrls; // List of image URLs
  final List<Map<String, dynamic>> sizesAndPrices; // Size and price list
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.supplierId,
    required this.isRefill,
    required this.productName,
    required this.productDescription,
    required this.imageUrls,
    required this.sizesAndPrices,
    this.createdAt,
  });

  // Factory constructor to create a ProductModel from Firestore data
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      supplierId: data['supplierId'] ?? '',
      isRefill: data['isRefill'] ?? false,
      productName: data['productName'] ?? '',
      productDescription: data['productDescription'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      sizesAndPrices: List<Map<String, dynamic>>.from(data['sizesAndPrices'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert ProductModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'id':id,
      'supplierId': supplierId,
      'isRefill': isRefill,
      'productName': productName,
      'productDescription': productDescription,
      'imageUrls': imageUrls,
      'sizesAndPrices': sizesAndPrices,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
