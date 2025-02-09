import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/supplier_product_card.dart';

class ProductListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteProduct(String productId, BuildContext context) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Products', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products available."));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final productDoc = products[index];
              final product = productDoc.data() as Map<String, dynamic>;
              final productId = productDoc.id;

              return SupplierProductCard(
                productId: productId, // Pass product ID
                productName: product['productName'] ?? 'No Name',
                description: product['description'] ?? 'No Description',
                price: product['price']?.toDouble() ?? 0.0,
                sizes: List<String>.from(product['sizes'] ?? []),
                images: List<String>.from(product['images'] ?? []),
                onDelete: () => _deleteProduct(productId, context), // Handle delete
              );
            },
          );
        },
      ),
    );
  }
}
