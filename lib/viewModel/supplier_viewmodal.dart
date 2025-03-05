import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SupplierViewModel extends ChangeNotifier {
  DocumentSnapshot? _supplier;
  List<DocumentSnapshot> _products = [];

  DocumentSnapshot? get supplier => _supplier;
  List<DocumentSnapshot> get products => _products;

  Future<void> fetchSupplierDetails(String supplierId) async {
    try {
      // Fetch supplier details
      var supplierSnapshot = await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .get();

      _supplier = supplierSnapshot;

      // Fetch products for the supplier
      var productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('supplierId', isEqualTo: supplierId) // Updated field name
          .get();


      _products = productsSnapshot.docs;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching supplier details: $e");
    }
  }
}
