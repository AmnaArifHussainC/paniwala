import 'package:flutter/material.dart';
import 'package:paniwala/view/user_auth/signin.dart';
import '../../widgets/custome_btn_auth.dart';
import '../../widgets/custome_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Register Title
            const Text(
              "Register",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Full Name Field
            CustomTextField(
              controller: fullNameController,
              hintText: "Full Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 10),

            // Email Field
            CustomTextField(
              controller: emailController,
              hintText: "Email",
              icon: Icons.email,
            ),
            const SizedBox(height: 10),

            // Password Field with Visibility Toggle
            CustomTextField(
              controller: passwordController,
              hintText: "Password",
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 10),

            // Confirm Password Field
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

            const SizedBox(height: 10),

            // Google Sign-In Button
            ElevatedButton.icon(
              onPressed: () {
                debugPrint("Google Sign-In Pressed");
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

            const SizedBox(height: 20),

            // Login Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
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
    );
  }
}
