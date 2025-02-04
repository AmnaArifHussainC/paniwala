import 'package:flutter/material.dart';
import 'package:paniwala/splash_screen.dart';
import 'package:paniwala/view/user_screen/dash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SplashScreen(),
      home: HomeScreen(),
    );
  }
}


