import 'package:flutter/material.dart';
import 'package:paniwala/services/auth/rider_auth.dart';
import 'package:paniwala/utils/auth_validation/validations.dart';

class CustomDrawer extends StatelessWidget {
  @override
  final RiderAuthService authservice = RiderAuthService();
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
                  "Rider Name",  // Replace with actual user name or dynamic data
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Handle Profile click
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: const Text('Earnings'),
            onTap: () {
              // Handle Earnings click
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
            onTap: () async{
              await authservice.signOut();
              Navigator.of(context);
            },
          ),
        ],
      ),
    );
  }
}
