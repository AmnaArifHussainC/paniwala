import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    _checkUserFirstTime();
  }

  Future<void> _checkUserFirstTime()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      // Mark that onboarding has been seen
      await prefs.setBool('isFirstTime', false);
      // Navigate to the Onboarding Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      // Navigate to the Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChooseAccountScreen()),
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
            Image.asset('assets/images/icon.png', width: 200),
          ],
        ),
      ),
    );
  }
}
