import 'package:flutter/material.dart';

class RiderDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Rider Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text('Rider Name', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('Location: Lahore', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.blue),
              title: Text('Delivery History'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Deliveries', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  deliveryItem('Electronics', '12:30 PM - 1:30 PM'),
                  deliveryItem('Groceries', '2:00 PM - 3:00 PM'),
                  deliveryItem('Furniture', '4:30 PM - 5:30 PM'),
                  deliveryItem('Clothing', '6:00 PM - 7:00 PM'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget deliveryItem(String category, String time) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.local_shipping, color: Colors.blue),
        title: Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
        onTap: () {},
      ),
    );
  }
}
