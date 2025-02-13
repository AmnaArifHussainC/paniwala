import 'package:flutter/material.dart';
import 'package:paniwala/view/authentication/consumer/consumer_login_screen.dart';
import 'package:paniwala/view/consumer/consumer_dashboard.dart';
import 'package:paniwala/view/supplier/supplier_dashboard.dart';
import 'package:paniwala/view/rider/rider_dashboard.dart';
import 'package:paniwala/view/admin/admin_dashboard.dart';
import 'package:paniwala/view_model/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
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
    await Future.delayed(Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _navigateBasedOnRole(user.uid);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen(authViewModel: AuthViewModel())),
      );
    }
  }

  Future<void> _navigateBasedOnRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'] ?? 'consumer'; // Default role

        Widget nextScreen;
        switch (role) {
          case 'consumer':
            nextScreen = HomeScreen();
            break;
          // case 'supplier':
          //   nextScreen = SupplierDashboard();
          //   break;
          // case 'rider':
          //   nextScreen = RiderDashboard();
          //   break;
          // case 'admin':
          //   nextScreen = AdminDashboard();
          //   break;
          default:
            nextScreen = HomeScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen(authViewModel: AuthViewModel())),
        );
      }
    } catch (e) {
      print("Error fetching user role: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen(authViewModel: AuthViewModel())),
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
            Image.asset('assets/images/icon.png', width: 200),
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
