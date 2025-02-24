import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/validators.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';
import '../../custom_widgets/custom_btn_auth.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../../screens/consumer/consumer_dashboard.dart';
import 'consumer_forgot_password.dart';
import 'consumer_register.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _signInUser() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      bool success = await authViewModel.loginUser(
        emailController.text.trim(),
        passController.text.trim(),
      );
      if (success) {
        final user = authViewModel.user;
        if (user != null && user.role.toLowerCase() == "customer") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign In Successful!')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid role. Access denied.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    bool success = await authViewModel.signInWithGoogle();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In Successful!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Paniwala",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text("Sign In", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    textinputtype: TextInputType.emailAddress,
                    validator: ValidationUtils.validateEmail,
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textinputtype: TextInputType.text,
                    validator: ValidationUtils.validatePassword,
                    controller: passController,
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      ),
                      child: const Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Sign In",
                    onPressed: authViewModel.isLoading ? null : _signInUser,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: authViewModel.isLoading ? null : _signInWithGoogle,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        ),
                        child: const Text("Register Now", style: TextStyle(color: Colors.blue)),
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
