import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/splash_screen.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: HomeScreen(),
    );
  }
}


