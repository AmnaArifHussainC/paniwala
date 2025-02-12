import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/user_auth/signin.dart';
import 'package:paniwala/view/rider_screen/rider_dash.dart';
import 'package:paniwala/view/supplier_screen/supplier_dash_screen.dart';
import 'package:paniwala/view/user_screen/dash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'choose_account_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash(); // Start navigation after splash
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

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3)); // Delay for splash screen

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      _navigateToScreen(OnboardingScreen());
      return;
    }

    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        String userId = currentUser.uid;

        // Check collections in order
        if (await _checkCollection('suppliers', userId)) {
          _navigateToScreen(SupplierDashboardScreen());
          return;
        }

        if (await _checkCollection('riders', userId)) {
          _navigateToScreen(RiderDashboard());
          return;
        }

        if (await _checkCollection('users', userId)) {
          _navigateToScreen(HomeScreen());
          return;
        }

        // If user is not found in any collection
        _navigateToScreen(SignInScreen());
      } catch (e) {
        print("Error during role check: $e");
        _navigateToScreen(SignInScreen());
      }
    } else {
      // Navigate to SignInScreen if not logged in
      _navigateToScreen(ChooseAccountScreen());
    }
  }

  Future<bool> _checkCollection(String collectionName, String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userId)
          .get();
      return userDoc.exists;
    } catch (e) {
      print("Error checking $collectionName: $e");
      return false;
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
