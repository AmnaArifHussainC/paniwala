import 'package:flutter/material.dart';
import '../config/services/product_add_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> uploadProduct({
    required bool isRefill,
    required String supplierId,
    required String productName,
    required String productDescription,
    required double productPrice,
    required List<String> imagePaths, // List of image paths
    required List<Map<String, dynamic>> sizesAndPrices, // Sizes and prices list
  }) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // Upload each image to Cloudinary and collect the URLs
      List<String> imageUrls = [];
      for (String imagePath in imagePaths) {
        final String? imageUrl = await _productService.uploadImageToCloudinary(imagePath);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      // Ensure all images uploaded successfully
      if (imageUrls.isEmpty) {
        throw Exception("No images uploaded.");
      }

      // Store product details in Firestore with image URLs
      await _productService.storeProductInFirestore(
        sizesAndPrices: sizesAndPrices,
        isRefill: isRefill,
        supplierId: supplierId,
        productName: productName,
        productDescription: productDescription,
        productPrice: productPrice,
        imageUrls: imageUrls, // Pass list of image URLs
      );
    } catch (e) {
      _setErrorMessage('Failed to upload product: $e');
    } finally {
      _setLoading(false);
    }
  }
}
