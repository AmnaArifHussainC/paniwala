import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SupplierDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Supplier Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: Colors.white),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // FIX: Prevent overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/avatar.png'), // Change to your asset
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dashboard Cards in a Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DashboardCard(title: "Earnings", value: "₹6002", percentage: "+5%", icon: Icons.attach_money),
                    DashboardCard(title: "Total Orders", value: "1043", percentage: "+15%", icon: Icons.receipt),
                    DashboardCard(title: "Total Products", value: "107", percentage: "+5%", icon: Icons.production_quantity_limits),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // New Orders Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Order",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all orders
                    },
                    child: const Text("See All Orders", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),

            // Orders List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  OrderCard(
                    orderId: "#20211028-07104354",
                    date: "2 Nov 2021 04:24 PM",
                    customerName: "Ankit Gajera",
                    amount: "₹230.44",
                    status: "Placed",
                  ),
                  OrderCard(
                    orderId: "#20211028-07104354",
                    date: "2 Nov 2021 04:24 PM",
                    customerName: "Ankit Gajera",
                    amount: "₹230.44",
                    status: "Placed",
                  ),
                  OrderCard(
                    orderId: "#20211028-07104354",
                    date: "2 Nov 2021 04:24 PM",
                    customerName: "Ankit Gajera",
                    amount: "₹230.44",
                    status: "Placed",
                  ),
                  OrderCard(
                    orderId: "#20211028-07104354",
                    date: "2 Nov 2021 04:24 PM",
                    customerName: "Ankit Gajera",
                    amount: "₹230.44",
                    status: "Placed",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // FIX: Extra spacing to avoid overflow
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: "Earnings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Handle add action
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Dashboard Card Widget
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final IconData icon;

  DashboardCard({required this.title, required this.value, required this.percentage, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Fixed width for horizontal scrolling
      margin: const EdgeInsets.only(right: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(percentage, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

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
