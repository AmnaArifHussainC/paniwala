import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Future<void> storeProductInFirestore({
    required bool isRefill,
    required String supplierId,
    required String productName,
    required String productDescription,
    required double productPrice,
    required List<String> imageUrls, // List of image URLs
    required List<Map<String, dynamic>> sizesAndPrices, // List of size and price maps
  }) async {
    try {
      final productData = {
        'isRefill': isRefill,
        'productName': productName,
        'productDescription': productDescription,
        'productPrice': productPrice,
        'imageUrls': imageUrls, // Store as an array
        'sizesAndPrices': sizesAndPrices, // Store size and price list
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add to supplier's subcollection
      await _firestore
          .collection('suppliers')
          .doc(supplierId)
          .collection('products')
          .add(productData);

      print('Product added successfully.');
    } catch (e) {
      print('Error adding product to Firestore: $e');
    }
  }
}
