import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/config/services/auth_service.dart';
import 'package:paniwala/view/startup/choose_account_screen.dart';
import 'package:paniwala/view/supplier/product/supplier_drawer_pro_list_screen.dart';

import '../authentication/rider/rider_register.dart';

class CustomDrawer extends StatelessWidget {
  final String supplierId; // Supplier ID passed to the drawer

  CustomDrawer({Key? key, required this.supplierId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.white),
                const SizedBox(height: 10),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Register a Rider'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RiderRegisterScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Products'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupplierProductsScreen(
                            supplierId: supplierId,
                          )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Earnings'),
            onTap: () {
              Navigator.pushNamed(context, '/earnings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final confirmLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: CupertinoColors.inactiveGray),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );

              if (confirmLogout == true) {
                final authservise = AuthService();
                authservise.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseAccountScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
