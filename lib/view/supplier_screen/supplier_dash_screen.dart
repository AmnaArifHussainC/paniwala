import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:paniwala/view/supplier_screen/supplier_add_product.dart';
import 'package:paniwala/view/supplier_screen/supplier_drawer.dart';

import '../../widgets/supplier_dashboard_card.dart';
import '../../widgets/supplire_dash_order_card.dart';

class SupplierDashboardScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
      drawer: CustomDrawer(),  // Add the custom drawer here

      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Supplier Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white, // Set the hamburger icon to white
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();  // Use the GlobalKey to open the drawer
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: Colors.white),
            onPressed: () {
              // Handle notifications
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
                color: Colors.blue,
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

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Replace 'supplierId' with the actual supplier ID from your app's state or data
          String supplierId = "exampleSupplierId"; // Fetch or set the supplier ID dynamically

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(supplierId: supplierId),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

