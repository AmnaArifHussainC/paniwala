import 'package:flutter/material.dart';
import 'package:paniwala/view/authentication/consumer/consumer_login_screen.dart';
import '../../../config/custome_widgets/custome_btn_auth.dart';
import '../../../config/custome_widgets/custome_text_field.dart';
import '../../../config/utils/validators.dart';
import '../../../view_model/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  final AuthViewModel authViewModel;

  const RegisterScreen({Key? key, required this.authViewModel})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate email using ValidationUtils
    final emailError = ValidationUtils.validateEmail(email);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError)),
      );
      return;
    }

    bool isSuccess = await widget.authViewModel.register(name, email, password);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(authViewModel: AuthViewModel()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration failed. Please try again.")),
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
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    textinputtype: TextInputType.text,
                    validator: (value) =>
                        ValidationUtils.validateFullName(value),
                    controller: fullNameController,
                    hintText: "Full Name",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textinputtype: TextInputType.emailAddress,
                    validator: (value) => ValidationUtils.validateEmail(value?.trim()),
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textinputtype: TextInputType.text,
                    validator: (value) =>
                        ValidationUtils.validatePassword(value),
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textinputtype: TextInputType.text,
                    validator: (value) =>
                        ValidationUtils.validateConfirmPassword(
                            passwordController.text, value),
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: widget.authViewModel.isLoading
                        ? "Loading..."
                        : "Register",
                    onPressed:
                        widget.authViewModel.isLoading ? null : _registerUser,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen(
                                        authViewModel: AuthViewModel(),
                                      )));
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
      ),
    );
  }
}
