import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a new supplier to Firestore
  Future<void> addSupplier({
    required String supplierId,
    required String name,
    required String phone,
    required String cnic,
    required String certificateUrl, // Assume the document is uploaded
  }) async {
    try {
      await _firestore.collection('suppliers').doc(supplierId).set({
        'name': name,
        'phone': phone,
        'cnic': cnic,
        'certificateUrl': certificateUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Error adding supplier: $e");
    }
  }

  /// Add a product under the supplier's products subcollection
  Future<void> addProduct({
    required String supplierId,
    required String productName,
    required String description,
    required double price,
    required List<String> sizes,
    required List<String> images, // Image URLs
  }) async {
    try {
      await _firestore
          .collection('suppliers')
          .doc(supplierId)
          .collection('products')
          .add({
        'productName': productName,
        'description': description,
        'price': price,
        'sizes': sizes,
        'images': images,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Error adding product: $e");
    }
  }

  /// Fetch products for a specific supplier
  Future<List<Map<String, dynamic>>> getProducts(String supplierId) async {
    try {
      QuerySnapshot productsSnapshot = await _firestore
          .collection('suppliers')
          .doc(supplierId)
          .collection('products')
          .get();

      return productsSnapshot.docs
          .map((doc) => {
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      })
          .toList();
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  /// Upload image to Firebase Storage
  Future<String> uploadImage(String supplierId, File image) async {
    if (!await image.exists()) {
      throw Exception("File does not exist: ${image.path}");
    }

    if (supplierId.isEmpty) {
      throw Exception("Supplier ID is empty.");
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('suppliers/$supplierId/products/${DateTime.now().millisecondsSinceEpoch}.jpg');

      print("Uploading to path: ${storageRef.fullPath}");

      final uploadTask = await storageRef.putFile(image);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      print("Upload successful. File URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error during image upload: $e");
      throw Exception("Error uploading image: $e");
    }
  }
}
