import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct({
    required String supplierId,
    required String productName,
    required String description,
    required double price,
    required List<String> sizes,
  }) async {
    try {
      // Reference to the supplier's product collection
      final productsCollection = _firestore
          .collection('suppliers')
          .doc(supplierId)
          .collection('products');

      // Add the product to Firestore
      await productsCollection.add({
        'productName': productName,
        'description': description,
        'price': price,
        'sizes': sizes, // Storing the sizes as an array
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }
}
