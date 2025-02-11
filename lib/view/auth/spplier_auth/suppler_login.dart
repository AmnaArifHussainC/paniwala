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
             builder: (context) =>  SupplierDashboardScreen(),
           ),
         );
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Sign In successful!")),
         );
       } else {
         // Show error message
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(result)),
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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Dynamic padding
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // Centered "Sign In" Title
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
                    validator: (value) => ValidationUtils.validateEmail(value),
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),

                  // Password Field
                  CustomTextField(
                    validator: (value) => ValidationUtils.validatePassword(value),
                    controller: passController,
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  // Forgot Password? Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to Forgot Password screen
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
                      debugPrint("Sign In Pressed");
                      _suppliersignIn(context);
                    },
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),



                  // Register Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierRegisterScreen()));
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
