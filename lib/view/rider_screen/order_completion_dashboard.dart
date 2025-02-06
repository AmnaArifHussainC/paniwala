import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OrderCompletionDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text('Order Completion', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _summaryCard('Total Orders', '12', Colors.blue.shade700, LucideIcons.truck),
                ),
                const SizedBox(width: 8), // Reduce spacing if needed
                Expanded(
                  child: _summaryCard('Total Earnings', 'PKR 45,000', Colors.green.shade700, LucideIcons.wallet),
                ),
              ],
            ),



            const SizedBox(height: 20),

            const Text(
              'Completed Deliveries',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // List of Completed Orders
            Expanded(
              child: ListView(
                children: [
                  _orderCard('Order #101', 'Filtered Water - 19L', 'Completed at 10:30 AM'),
                  _orderCard('Order #102', 'Mineral Water - 10L', 'Completed at 1:00 PM'),
                  _orderCard('Order #103', 'Alkaline Water - 20L', 'Completed at 3:45 PM'),
                  _orderCard('Order #104', 'Spring Water - 15L', 'Completed at 5:15 PM'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String value, Color color, IconData icon) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              Text(
                value,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
          child: const Icon(LucideIcons.checkCircle, color: Colors.green),
        ),
        title: Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$details\n$time', style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}

