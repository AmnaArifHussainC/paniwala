import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/order_model.dart';

class SupplierAllOrdersScreen extends StatelessWidget {
  final String supplierId; // Pass the supplier's ID to this screen

  const SupplierAllOrdersScreen({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Orders", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 4.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("suppliers")
            .doc(supplierId)
            .collection("orders")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No orders found.", style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }

          final orders = snapshot.data!.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    "Order ID: ${order.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text("Customer: ${order.name}", style: const TextStyle(fontSize: 14)),
                      Text("Phone: ${order.phoneNumber}", style: const TextStyle(fontSize: 14)),
                      Text("Total Price: Rs,${order.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14)),
                      Text("Quantity: ${order.quantity}", style: const TextStyle(fontSize: 14)),
                      if (order.selectedSize != null)
                        Text("Size: ${order.selectedSize}L", style: const TextStyle(fontSize: 14)),
                      if (order.dailyDelivery)
                        Text("Delivery Time: ${order.deliveryTime}", style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      Text("Order Date: ${order.timestamp.toDate().toString().split(' ')[0]}", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupplierOrderDetailsScreen(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SupplierOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const SupplierOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text("Customer Name: ${order.name}", style: const TextStyle(fontSize: 16)),
            Text("Phone Number: ${order.phoneNumber}", style: const TextStyle(fontSize: 16)),
            Text("Address: ${order.address}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 8),
            const Text("Order Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text("Total Price: Rs,${order.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
            Text("Quantity: ${order.quantity}", style: const TextStyle(fontSize: 16)),
            if (order.selectedSize != null)
              Text("Size: ${order.selectedSize}L", style: const TextStyle(fontSize: 16)),
            if (order.dailyDelivery)
              Text("Daily Delivery Time: ${order.deliveryTime}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 8),
            Text(
              "Order Date: ${order.timestamp.toDate().toString()}",
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
