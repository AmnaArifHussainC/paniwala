import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/user_auth/signin.dart';
import 'package:paniwala/view/user_screen/dash_screen.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';

import '../../../services/auth/customer_auth.dart';
import '../../../utils/auth_validation/validations.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  // controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  void _registerUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      String? errorMessage = await _authService.signUp(email, password);
      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );

        // Navigate to the HomeScreen and clear previous navigation stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your target screen widget
              (Route<dynamic> route) => false, // Removes all previous routes
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Full Name Text Field
                  CustomTextField(
                    validator: (value) => ValidationUtils.validateFullName(value),
                    controller: fullNameController,
                    hintText: "Full Name",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),

                  // Email Text Field
                  CustomTextField(
                    validator: (value) => ValidationUtils.validateEmail(value),
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),

                  // Password Text Field
                  CustomTextField(
                    validator: (value) => ValidationUtils.validatePassword(value),
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // Confirm Password Text Field
                  CustomTextField(
                    validator: (value) => ValidationUtils.validateConfirmPassword(passwordController.text, value),
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Register Button
                  CustomButton(
                    text: "Register",
                    onPressed: () {
                      _registerUser(context);  // Trigger form validation
                    },
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  // Google Sign In Button
                  ElevatedButton.icon(
                    onPressed: () {
                      debugPrint("Google Sign In Pressed");
                    },
                    icon: Image.asset("assets/images/google.png", height: 24),
                    label: const Text("Sign up with Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),

                  // Already have an account? Text
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignInScreen()),
                          );
                        },
                        child: const Text(
                          "Login",
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
    );
  }
}
