import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/view_model/auth_viewmodel.dart';

import '../../config/services/auth_service.dart';
import '../authentication/consumer/consumer_login_screen.dart';

class CustomUserDrawer extends StatelessWidget {
  const CustomUserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header (you can customize it based on your design)
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
                  "User Name",  // Replace with actual user name or dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),

          // "Login as Supplier" button
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Login as Supplier'),
            onTap: () {
              // Implement navigation to Supplier login screen
            },
          ),

          // List of Drawer Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Implement navigation when the user taps on Home
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.heart_fill),
            title: const Text('Favorite'),
            onTap: () {
              // Implement navigation when the user taps on Home
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              // Implement navigation when the user taps on Profile
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.shopping_cart),
            title: const Text('Order History'),
            onTap: () {
              // Implement navigation when the user taps on Order History
              Navigator.pushReplacementNamed(context, '/order_history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Implement navigation when the user taps on Settings
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () async{
              final authservise = AuthService();
              authservise.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInScreen(authViewModel: AuthViewModel(),)), (route)=> false);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
