import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/rider_auth/rider_reg.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // Set the background color to white
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, size: 80, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Supplier Name", // Replace with actual user name or dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigate to Profile screen
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: const Text('Earnings'),
            onTap: () {
              // Navigate to Earnings screen
              Navigator.pushNamed(context, '/earnings');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: const Text('Orders'),
            onTap: () {
              // Navigate to Orders screen
              Navigator.pushNamed(context, '/orders');
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: const Text('Products'),
            onTap: () {
              // Navigate to Products screen
              Navigator.pushNamed(context, '/products');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: const Text('Register a Rider'),
            onTap: () {
              // Navigate to Rider Registration screen
              Navigator.push(context, MaterialPageRoute(builder: (context)=> RiderRegisterScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle Settings click
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle Logout click
            },
          ),
        ],
      ),
    );
  }
}
