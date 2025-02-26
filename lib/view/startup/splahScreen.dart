import 'package:flutter/material.dart';
import 'package:paniwala/core/services/auth_service.dart';
import 'package:paniwala/view/startup/choose_account_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/rider_model.dart';
import '../../model/supplier_model.dart';
import '../../model/user_model.dart';
import '../auth/consumer/consumer_login_screen.dart';
import '../screens/consumer/consumer_dashboard.dart';
import '../screens/suppliers/supplier_dashboard.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  final  _authService = AuthService();
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Show splash for 2 seconds

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;  //null to true

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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ChooseAccountScreen()),
            (route) => false, // This removes all previous routes from the stack
      );
    }
  }


  Future<void> _navigateBasedOnRole(String uid) async {
    try {
      print("Checking role for user with UID: $uid");

      final user = await _authService.getUserByUID(uid);

      if (user != null) {
        if (user is UserModel && user.role == 'customer') {
          print("User found in 'Users' collection with role: ${user.role}.");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
          );
          return;
        } else if (user is SupplierModel && user.role == 'supplier') {
          print("User found in 'Suppliers' collection with role: ${user.role}.");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SupplierDashboardScreen()),
                (route) => false,
          );
          return;
        } else if (user is RiderModel && user.role == 'rider') {
          print("User found in 'Riders' collection with role: ${user.role}.");
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => RiderDashboardScreen()),
          // );
          // return;
        }
      }
      print("User not found in Firestore or invalid role. Navigating to ChooseAccountScreen.");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ChooseAccountScreen()),
            (route) => false,
      );
    } catch (e) {
      print("Error fetching user role: $e");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
            (route) => false,
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
