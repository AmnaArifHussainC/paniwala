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
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final  _authService = AuthService();
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
      await prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _navigateBasedOnRole(user.uid);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ChooseAccountScreen()),
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
        MaterialPageRoute(builder: (context) => const ChooseAccountScreen()),
            (route) => false,
      );
    } catch (e) {
      print("Error fetching user role: $e");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
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
