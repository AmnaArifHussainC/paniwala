import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paniwala/view/auth/user_auth/forget_password.dart';
import 'package:paniwala/view/auth/user_auth/register.dart';
import 'package:paniwala/view/user_screen/dash_screen.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';

import '../../../services/auth/customer_auth.dart';
import '../../../services/firestore/user_db.dart';
import '../../../services/location/location_permission.dart';
import '../../../utils/auth_validation/validations.dart';
import '../../../utils/fetchLocation/fetch_location.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool _isLoading = false; // Loading state

  void _signinUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = emailController.text.trim();
      String password = passController.text.trim();

      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        // Sign in the user
        String? errorMessage = await _authService.signIn(email, password);
        if (errorMessage == null) {
          final userId = _authService.getCurrentUser()?.uid;
          if (userId != null) {

            // Fetch the user's location
            PermissionAndPositionService positionService = PermissionAndPositionService();
            DetailedAddressService addressService = DetailedAddressService();

            Position position = await positionService.fetchUserPosition();
            String detailedAddress = await addressService.getDetailedAddress(position);

            // Save the location to Firestore
            DatabaseService dbService = DatabaseService();
            await dbService.createOrUpdateUserDocument(userId, email, detailedAddress);

            // Display the location
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Your location: $detailedAddress")),
            );

            // Navigate to HomeScreen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An unexpected error occurred: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Paniwala",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Email Field
                      CustomTextField(
                        textinputtype: TextInputType.emailAddress,
                        validator: (value) => ValidationUtils.validateEmail(value),
                        controller: emailController,
                        hintText: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 10),
                      // Password Field
                      CustomTextField(
                        textinputtype: TextInputType.text,
                        validator: (value) => ValidationUtils.validatePassword(value),
                        controller: passController,
                        hintText: "Password",
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Sign In Button
                      CustomButton(
                        text: "Sign In",
                        onPressed: () {
                          _signinUser(context);
                        },
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10),
                      // Google Sign In Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          String? errorMessage = await _authService.googleLogin();
                          if (errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Google Sign-In successful!")),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          }
                        },
                        icon: Image.asset("assets/images/google.png", height: 24),
                        label: const Text("Signin with Google"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
