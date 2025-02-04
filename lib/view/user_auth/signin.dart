import 'package:flutter/material.dart';
import 'package:paniwala/view/user_auth/register.dart';
import '../../widgets/custome_btn_auth.dart';
import '../../widgets/custome_text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

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
            // Centered "Sign In" Title in Blue
            const Center(
              child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  // color: Colors.blue, // Blue Title
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

            // Password Field with Eye Icon
            CustomTextField(
              controller: passController,
              hintText: "Password",
              icon: Icons.lock,
              obscureText: true,
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
              label: Text("Sign in with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            // Register Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don’t have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  child: Text("Register",
                  style: TextStyle(
                    color: Colors.blue
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
