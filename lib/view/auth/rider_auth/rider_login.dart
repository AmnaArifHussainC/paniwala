import 'package:flutter/material.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';
import '../../../services/auth/rider_auth.dart';
import '../../../utils/auth_validation/validations.dart';
import '../../rider_screen/rider_dash.dart';

class RiderSignInScreen extends StatelessWidget {
  RiderSignInScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _riderLogin(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      RiderAuthService authService = RiderAuthService();

      String? result = await authService.signInRider(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      if (result == "Rider signed in successfully") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  RiderDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result ?? "An error occurred")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in valid credentials")),
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
                  const SizedBox(height: 20),

                  // Sign In Button
                  CustomButton(
                    text: "Sign In",
                    onPressed: () {
                      _riderLogin(context);
                    },
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
