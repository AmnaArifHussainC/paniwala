import 'package:flutter/material.dart';
import 'package:paniwala/view/authentication/consumer/consumer_login_screen.dart';
import 'package:paniwala/view/consumer/consumer_dashboard.dart';
import 'package:paniwala/view/startup/choose_account_screen.dart';
import 'package:paniwala/view/supplier/supplier_dashboard.dart';
import 'package:paniwala/view_model/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Show splash for 2 seconds

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Navigate to onboarding screen if first-time user
      await prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      return;
    }

    // Check if a user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Navigate based on user role
      await _navigateBasedOnRole(user.uid);
    } else {
      // Navigate to ChooseAccountScreen if no user is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChooseAccountScreen()),
      );
    }
  }

  Future<void> _navigateBasedOnRole(String uid) async {
    try {
      print("Checking role for user with UID: $uid");

      // Check in 'Users' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        final role = userDoc['role'];
        if (role == 'customer') {
          print("User found in 'Users' collection with role: $role.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          return;
        }
      }

      // Check in 'suppliers' collection
      DocumentSnapshot supplierDoc = await FirebaseFirestore.instance.collection('suppliers').doc(uid).get();
      if (supplierDoc.exists) {
        final role = supplierDoc['role'];
        if (role == 'supplier') {
          print("User found in 'suppliers' collection with role: $role.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SupplierDashboardScreen()),
          );
          return;
        }
      }

      // If user is not found in either collection or role is invalid
      print("User not found in Firestore or invalid role. Navigating to ChooseAccountScreen.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChooseAccountScreen()),
      );
    } catch (e) {
      print("Error fetching user role: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(authViewModel: AuthViewModel()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/icon.png', width: 200), // App logo
            const SizedBox(height: 20),
            const Text(
              "Paniwala",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
