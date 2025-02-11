import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/rider_auth/rider_reg.dart';
import 'package:paniwala/view/auth/spplier_auth/suppler_login.dart';
import '../../services/auth/supplier_auth.dart';
import 'drawer/product.dart';

class CustomDrawer extends StatelessWidget {
  final String supplierId; // Supplier ID passed to the drawer
  final SupplierAuthService _authService = SupplierAuthService(); // AuthService instance

  CustomDrawer({Key? key, required this.supplierId}) : super(key: key);

  Future<String> _fetchSupplierName() async {
    try {
      DocumentSnapshot supplierDoc =
      await FirebaseFirestore.instance.collection('suppliers').doc(supplierId).get();
      if (supplierDoc.exists) {
        return supplierDoc['companyName'] ?? 'Unknown Supplier';
      } else {
        return 'Unknown Supplier';
      }
    } catch (e) {
      print('Error fetching supplier name: $e');
      return 'Error';
    }
  }

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
                FutureBuilder<String>(
                  future: _fetchSupplierName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        "Error fetching name",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      );
                    } else {
                      return Text(
                        snapshot.data ?? "Unknown Supplier",
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Register a Rider'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RiderRegisterScreen()),
              );
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
                  builder: (context) => ProductListScreen(supplierId: supplierId),
                ),
              );
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
                      child: const Text('Cancel', style: TextStyle(color: CupertinoColors.inactiveGray),),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout", style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              );

              if (confirmLogout == true) {
                await _authService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SupplerLoginScreen()),
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
