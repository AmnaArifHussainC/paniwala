import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paniwala/view/startup/choose_account_screen.dart';
import '../../../core/services/auth_service.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';

class CustomUserDrawer extends StatefulWidget {
  final AuthViewModel authViewModel;

  const CustomUserDrawer({super.key, required this.authViewModel});

  @override
  _CustomUserDrawerState createState() => _CustomUserDrawerState();
}

class _CustomUserDrawerState extends State<CustomUserDrawer> {
  final AuthService _authService = AuthService(); // Initialize auth service
  String _userName = "User Name"; // Default name

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user name when drawer is created
  }

  Future<void> _fetchUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userData = await _authService.getUserByUID(user.uid); // Fetch user data from Firestore
      if (userData != null) {
        setState(() {
          _userName = userData.name ?? "User Name"; // Update UI with fetched name
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _userName, // Display fetched user name
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
            leading: const Icon(CupertinoIcons.shopping_cart),
            title: const Text('Order History'),
            onTap: () {
              // Future feature
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await widget.authViewModel.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseAccountScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text("Log Out", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
