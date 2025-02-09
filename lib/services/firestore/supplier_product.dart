import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct({
    required String productName,
    required String description,
    required double price,
    required List<String> sizes,
    // required List<String> images,
  }) async {
    try {
      await _firestore.collection('products').add({
        'productName': productName,
        'description': description,
        'price': price,
        'sizes': sizes,
        // 'images': images,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Error adding product: $e");
    }
  }
}
