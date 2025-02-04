import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/user_auth/signin.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  // controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Dynamic padding based on screen width
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
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
                  controller: fullNameController,
                  hintText: "Full Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),

                // Email Text Field
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  icon: Icons.email,
                ),
                const SizedBox(height: 10),

                // Password Text Field
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Confirm Password Text Field
                CustomTextField(
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
                    debugPrint("Register Pressed");
                  },
                  color: Colors.blue,
                ),

                // Google Sign In Button
                const SizedBox(height: 20),
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
    );
  }
}
