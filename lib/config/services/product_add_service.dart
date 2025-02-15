import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/product_model.dart';


class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload image to Cloudinary
  Future<String?> uploadImageToCloudinary(String filePath) async {
    final cloudinaryCloudName = 'dhirdggtq';
    final uploadPreset = 'paniwala_certificates';
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload');

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final responseBody = jsonDecode(responseData.body);

        // Return the secure URL
        return responseBody['secure_url'];
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Store product details in Firestore
  Future<void> storeProductInFirestore(ProductModel product, String supplierId) async {
    try {
      // Convert ProductModel to Firestore format
      final productData = product.toFirestore();

      // Add to supplier's subcollection
      await _firestore
          .collection('suppliers')
          .doc(supplierId)
          .collection('products')
          .doc(product.id)
          .set(productData);

      print('Product added successfully.');
    } catch (e) {
      print('Error adding product to Firestore: $e');
    }
  }

  // Fetch products from Firestore for a supplier
  Future<List<ProductModel>> fetchProducts(String supplierId) async {
    try {
      final querySnapshot = await _firestore
          .collection('suppliers')
          .doc(supplierId)
          .collection('products')
          .get();

      return querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }


  Future<void> deleteProductFromFirestore(String supplierId, String productId) async {
    try {
      await _firestore
          .collection('suppliers')
          .doc(supplierId)
          .collection('products')
          .doc(productId)
          .delete();
      print('Product deleted successfully.');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }


}
