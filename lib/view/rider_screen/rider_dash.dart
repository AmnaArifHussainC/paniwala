import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:paniwala/view/rider_screen/order_completion_dashboard.dart';
import 'package:paniwala/view/rider_screen/rider_drawer.dart';

class RiderDashboard extends StatelessWidget {
  // Define a GlobalKey for the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,  // Assign the key to the Scaffold
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),  // Add the custom drawer here
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        title: const Text(
          'Rider Dashboard',
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
      body: Column(
        children: [
          // Rider Info & Current Location
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome, Rider!',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'Lahore, Pakistan', // Dynamically fetch location
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Dashboard Options
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardButton(context, Icons.local_shipping, 'Deliveries', Colors.blue.shade700, () {}),
                _dashboardButton(context, Icons.history, 'History', Colors.blue.shade500, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderCompletionDashboard()),
                  );
                }),
                _dashboardButton(context, Icons.settings, 'Settings', Colors.blue.shade300, () {}),
              ],
            ),
          ),

          // Current Orders Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Deliveries',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        _orderCard('Order #001', 'Filtered Water - 19L', '12:30 PM - 1:00 PM'),
                        _orderCard('Order #002', 'Mineral Water - 10L', '2:00 PM - 2:30 PM'),
                        _orderCard('Order #003', 'Alkaline Water - 20L', '3:00 PM - 3:30 PM'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _orderCard(String orderId, String details, String time) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(LucideIcons.box, color: Colors.blue),
        ),
        title: Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$details\nTime: $time', style: const TextStyle(fontSize: 13)),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
          onPressed: () {
            // Navigate to order details
          },
        ),
      ),
    );
  }
}
