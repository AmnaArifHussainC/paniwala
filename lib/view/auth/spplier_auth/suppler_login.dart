import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/spplier_auth/supplier_reg.dart';
import 'package:paniwala/view/auth/user_auth/forget_password.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';


class SupplerLoginScreen extends StatelessWidget {
   SupplerLoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

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
                  controller: emailController,
                  hintText: "Email",
                  icon: Icons.email,
                ),
                const SizedBox(height: 10),

                // Password Field
                CustomTextField(
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
                  },
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),

                // Google Sign In Button
                ElevatedButton.icon(
                  onPressed: () {
                    debugPrint("Google Sign In Pressed");
                  },
                  icon: Image.asset("assets/images/google.png", height: 24),
                  label: const Text("Sign in with Google"),
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

                // Register Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierRegisterScreen()));
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
    );
  }
}
