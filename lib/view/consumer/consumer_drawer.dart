import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paniwala/view/startup/choose_account_screen.dart';
import 'package:paniwala/view_model/auth_viewmodel.dart';

class CustomUserDrawer extends StatelessWidget {
  final AuthViewModel authViewModel;
  CustomUserDrawer({super.key, required this.authViewModel});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // Get the logged-in user

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  user?.displayName ?? "User Name", // Display actual user name
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.heart_fill),
            title: const Text('Favorite'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.shopping_cart),
            title: const Text('Order History'),
            onTap: () => Navigator.pushReplacementNamed(context, '/order_history'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () async {
              await authViewModel.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ChooseAccountScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
