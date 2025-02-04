import 'package:flutter/material.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';

class RiderSignInScreen extends StatelessWidget {
  RiderSignInScreen({super.key});

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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Centered "Sign In" Title
                const Center(
                  child: Text(
                    "Rider Sign In",
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
                const SizedBox(height: 20),

                // Sign In Button
                CustomButton(
                  text: "Sign In",
                  onPressed: () {
                    debugPrint("Rider Sign In Pressed");
                  },
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
