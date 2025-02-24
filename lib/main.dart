import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/view/startup/splash_screen.dart';
import 'package:paniwala/viewModel/auth_provider_viewmodel.dart';
import 'package:paniwala/viewModel/consumer_dash_screen_viewmodel_pro.dart';
import 'package:paniwala/viewModel/location_on_dash_screens.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, // Use debug mode to bypass App Check
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>AuthViewModel()),
        ChangeNotifierProvider(create: (context)=>LocationViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
          iconTheme: IconThemeData(
            color: Colors.white,
          )
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
