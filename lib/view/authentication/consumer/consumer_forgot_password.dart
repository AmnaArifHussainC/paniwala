import 'package:flutter/material.dart';
import 'package:paniwala/config/services/auth_service.dart';

import '../../../config/custome_widgets/custome_text_field.dart';
import '../../../config/utils/validators.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authservice = AuthService();

  // Reset Password Function
  Future<bool> forgetPassword(String email, BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      bool success = await _authservice.resetPassword(emailController.text.trim());
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password reset link has been sent to your email. Kindly check your inbox.",
            ),
            backgroundColor: Colors.green,
          ),
        );
        emailController.clear();
        return true; // ✅ Return true on success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to send reset link. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
        return false; // ✅ Return false on failure
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid email."),
          backgroundColor: Colors.red,
        ),
      );
      return false; // ✅ Return false if validation fails
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
          "Reset Password",
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
                  const Center(
                    child: Text(
                      "Forgot Password?",
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
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // Reset Password Button
                  ElevatedButton(
                    onPressed: () async {
                      forgetPassword(emailController.text.trim(), context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text("Send Reset Link", style: TextStyle(color: Colors.white)),
                    ),
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
