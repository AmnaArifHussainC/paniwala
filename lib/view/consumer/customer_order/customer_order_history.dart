import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/order_model.dart';

class UserAllOrderScreen extends StatelessWidget {
  final String userId; // Pass the user's ID to this screen

  const UserAllOrderScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .collection("orders")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No orders found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
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
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    "Order ID: ${order.id}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text("Name: ${order.name}"),
                      Text("Address: ${order.address}"),
                      Text("Total Price: Rs,${order.totalPrice.toStringAsFixed(2)}"),
                      Text("Quantity: ${order.quantity}"),
                      if (order.selectedSize != null)
                        Text("Size: ${order.selectedSize}L"),
                      if (order.dailyDelivery)
                        Text("Daily Delivery Time: ${order.deliveryTime}"),
                      Text(
                        "Order Date: ${order.timestamp.toDate().toString().split(' ')[0]}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: order),
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

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order ID: ${order.id}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Name: ${order.name}", style: const TextStyle(fontSize: 16)),
                Text("Phone: ${order.phoneNumber}", style: const TextStyle(fontSize: 16)),
                Text("Address: ${order.address}", style: const TextStyle(fontSize: 16)),
                const Divider(height: 24, thickness: 1.5),
                Text(
                  "Order Details",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Total Price: Rs,${order.totalPrice.toStringAsFixed(2)}"),
                Text("Quantity: ${order.quantity}"),
                if (order.selectedSize != null)
                  Text("Size: ${order.selectedSize}L"),
                if (order.dailyDelivery)
                  Text("Daily Delivery Time: ${order.deliveryTime}"),
                const Divider(height: 24, thickness: 1.5),
                Text(
                  "Order Date: ${order.timestamp.toDate().toString()}",
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
