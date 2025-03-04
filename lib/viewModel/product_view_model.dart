import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/utils/cloudinary.dart';
import '../model/product_model.dart';


class ProductViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  List<Map<String, dynamic>> supplierProducts = [];


  bool isLoading = false;

  // Fetch products of the logged-in supplier

  Future<void> addProduct({
    required String supplierId,
    required bool isRefill,
    required String productName,
    required String productDescription,
    required List<String> imagePaths,
    required List<Map<String, dynamic>> sizesAndPrices,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // Upload images to Cloudinary and get URLs
      List<String> imageUrls = [];
      for (String path in imagePaths) {
        String? url = await _cloudinaryService.uploadToCloudinary(path);
        if (url != null) {
          imageUrls.add(url);
        }
      }

      // Generate product ID
      DocumentReference productRef = _firestore.collection('products').doc();

      // Create product model
      ProductModel product = ProductModel(
        id: productRef.id,
        supplierId: supplierId,
        isRefill: isRefill,
        productName: productName,
        productDescription: productDescription,
        imageUrls: imageUrls,
        sizesAndPrices: sizesAndPrices,
        createdAt: DateTime.now(),
      );

      // Save product to Firestore
      await productRef.set(product.toFirestore());

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error adding product: $e");
    }
  }

  // Fetch products of the logged-in supplier
  Future<void> fetchSupplierProducts() async {
    final String? supplierId = FirebaseAuth.instance.currentUser?.uid;
    if (supplierId == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('products')
          .where('supplierId', isEqualTo: supplierId)
          .get();

      supplierProducts = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching products: $e");
    }

    isLoading = false;
    notifyListeners();
  }
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      supplierProducts.removeWhere((product) => product['id'] == productId);
      notifyListeners();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }
}
