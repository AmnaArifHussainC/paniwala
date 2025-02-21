import 'package:flutter/material.dart';

import '../../view_model/auth_viewmodel.dart';
import '../startup/choose_account_screen.dart';

class RiderDrawer extends StatelessWidget {
  final AuthViewModel authViewModel;
  const RiderDrawer({super.key,required this.authViewModel});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text("Rider Name"),
            accountEmail: Text("rider@example.com"),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person, size: 50, color: Colors.blue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Order History"),
            onTap: () {
              // Navigate to Order History screen (implement later)
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async{
              await authViewModel.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseAccountScreen(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
