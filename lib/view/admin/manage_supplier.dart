import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String supplierId;
  final Map<String, dynamic> requestData;

  RequestDetailsScreen({super.key, required this.supplierId, required this.requestData});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateSupplierStatus(BuildContext context, String newStatus) async {
    try {
      // Update supplier's status
      await firestore.collection('suppliers').doc(supplierId).update({
        'verified': newStatus == "Accepted",
        'blocked': newStatus == "Blocked",
      });

      // Update the request status in admin collection
      await firestore
          .collection('admin')
          .doc('admin1')
          .collection('request')
          .doc(supplierId)
          .update({
        'status': newStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Supplier request marked as $newStatus."),
      ));

      Navigator.pop(context); // Go back to admin main screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${requestData['email']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("CNIC: ${requestData['cnic']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Phone: ${requestData['phone']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => updateSupplierStatus(context, "Accepted"),
                  child: const Text("Accept"),
                ),
                ElevatedButton(
                  onPressed: () => updateSupplierStatus(context, "Rejected"),
                  child: const Text("Reject"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () => updateSupplierStatus(context, "Blocked"),
                  child: const Text("Block"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
