import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paniwala/onboarding_screen.dart';
import 'package:paniwala/view/auth/user_auth/signin.dart';
import 'package:paniwala/view/user_screen/dash_screen.dart'; // Import HomeScreen

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Delay for splash screen display
    await Future.delayed(const Duration(seconds: 3));

    // Check if the app is being opened for the first time
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true; // Default to true

    if (isFirstTime) {
      // Mark as not first time and navigate to OnboardingScreen
      await prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      // Check if the user is logged in
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Navigate to HomeScreen if user is logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Navigate to SignInScreen if not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
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
