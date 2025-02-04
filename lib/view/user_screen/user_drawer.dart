import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/spplier_auth/suppler_login.dart';
import 'package:paniwala/view/auth/spplier_auth/supplier_reg.dart';

class CustomUserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header (you can customize it based on your design)
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, size: 80, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "User Name",  // Replace with actual user name or dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),

          // "Login as Supplier" button
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Login as Supplier'),
            onTap: () {
              // Implement navigation to Supplier login screen
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SupplierRegisterScreen()));
            },
          ),

          // List of Drawer Items
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Implement navigation when the user taps on Home
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.heart_fill),
            title: Text('Favorite'),
            onTap: () {
              // Implement navigation when the user taps on Home
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              // Implement navigation when the user taps on Profile
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.shopping_cart),
            title: Text('Order History'),
            onTap: () {
              // Implement navigation when the user taps on Order History
              Navigator.pushReplacementNamed(context, '/order_history');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Implement navigation when the user taps on Settings
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () {
              // Implement logout functionality here
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
