import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/spplier_auth/supplier_reg.dart';
import 'package:paniwala/view/auth/user_auth/forget_password.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';
import '../../../services/auth/supplier_auth.dart';
import '../../../utils/auth_validation/validations.dart';
import '../../supplier_screen/supplier_dash_screen.dart';

class SupplerLoginScreen extends StatelessWidget {
  SupplerLoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _suppliersignIn(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authService = SupplierAuthService();

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Perform sign-in logic
      String? result = await authService.signIn(
        emailController.text.trim(),
        passController.text.trim(),
      );

      // Hide loading indicator
      Navigator.of(context).pop();

      if (result == null) {
        // If successful, navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SupplierDashboardScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign In successful!")),
        );
      } else {
        // Handle different error messages returned from the backend
        String message;
        if (result.contains("blocked")) {
          message = "Your account has been blocked. Contact admin for support.";
        } else if (result.contains("rejected")) {
          message = "Your registration was rejected by the admin.";
        } else if (result.contains("pending approval")) {
          message = "Your account is pending approval. Please wait for admin approval.";
        } else {
          message = result; // Generic error message
        }

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please correct the errors in the form.")),
      );
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
                  CustomTextField(
                    textinputtype: TextInputType.emailAddress,
                    validator: (value) => ValidationUtils.validateEmail(value),
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
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
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Sign In",
                    onPressed: () {
                      debugPrint("Sign In Pressed");
                      _suppliersignIn(context);
                    },
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const SupplierRegisterScreen(),
                            ),
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
    );
  }
}
