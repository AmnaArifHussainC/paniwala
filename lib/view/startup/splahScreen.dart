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
    await Future.delayed(Duration(seconds: 2)); // Show splash for 2 seconds

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Navigate to onboarding screen if first-time user
      await prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
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
        MaterialPageRoute(builder: (context) => ChooseAccountScreen()),
      );
    }
  }


  Future<void> _navigateBasedOnRole(String uid) async {
    try {
      List<String> collections = ['Users', 'suppliers', 'riders', 'admins'];
      DocumentSnapshot? userDoc;
      String? userRole;

      // Check all collections
      for (String collection in collections) {
        userDoc = await FirebaseFirestore.instance.collection(collection).doc(uid).get();

        if (userDoc.exists) {
          userRole = userDoc['role'];
          print("User found in $collection with role: $userRole");
          break; // Exit loop once user is found
        }
      }

      if (userRole == null) {
        print("User role not found, navigating to ChooseAccountScreen.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChooseAccountScreen()),
        );
        return;
      }

      Widget nextScreen;
      switch (userRole) {
        case 'consumer':
          nextScreen = HomeScreen();
          break;
        case 'supplier':
          nextScreen = SupplierDashboardScreen();
          break;
        default:
          nextScreen = ChooseAccountScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
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
