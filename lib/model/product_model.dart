
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id; // Product ID
  final bool isRefill;
  final String productName;
  final String productDescription;
  final double productPrice;
  final List<String> imageUrls; // List of image URLs
  final List<Map<String, dynamic>> sizesAndPrices; // Size and price list
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.isRefill,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.imageUrls,
    required this.sizesAndPrices,
    this.createdAt,
  });

  // Factory constructor to create a ProductModel from Firestore data
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      isRefill: data['isRefill'] ?? false,
      productName: data['productName'] ?? '',
      productDescription: data['productDescription'] ?? '',
      productPrice: (data['productPrice'] ?? 0).toDouble(),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      sizesAndPrices: List<Map<String, dynamic>>.from(data['sizesAndPrices'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert ProductModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'isRefill': isRefill,
      'productName': productName,
      'productDescription': productDescription,
      'productPrice': productPrice,
      'imageUrls': imageUrls,
      'sizesAndPrices': sizesAndPrices,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
