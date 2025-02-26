import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/components/custome_widgets/custome_btn_auth.dart';
import '../../../config/components/custome_widgets/custome_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';

class RiderSignInScreen extends StatefulWidget {
  const RiderSignInScreen({super.key});

  @override
  _RiderSignInScreenState createState() => _RiderSignInScreenState();
}

class _RiderSignInScreenState extends State<RiderSignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              child: Consumer<AuthViewModel>(
                builder: (context, authViewModel, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      const SizedBox(height: 20),

                      CustomButton(
                        text: authViewModel.isLoading ? "Loading..." : "Sign In",
                        onPressed: authViewModel.isLoading
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            final password = passController.text.trim();
                            print("Attempting to log in rider...");

                            bool success =
                            await authViewModel.loginRider(email, password);

                            if (success) {
                              print("Login successful! Navigating to dashboard.");
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => RiderDashboard()),
                              // );
                            } else {
                              print("Login failed: Invalid credentials.");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Invalid login credentials.")),
                              );
                            }
                          }
                        },
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10),

                      if (authViewModel.isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
