import 'package:flutter/material.dart';

// Order Card Widget
class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String customerName;
  final String amount;
  final String status;

  OrderCard({required this.orderId, required this.date, required this.customerName, required this.amount, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(orderId, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text("Customer Name: $customerName", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Delivery Status: $status", style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
