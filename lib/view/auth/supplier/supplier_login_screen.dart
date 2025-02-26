import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/supplier/supplier_register_screen.dart';
import 'package:paniwala/viewModel/auth_provider_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../config/components/custome_widgets/custome_btn_auth.dart';
import '../../../config/components/custome_widgets/custome_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../screens/suppliers/supplier_dashboard.dart';
import '../consumer/consumer_forgot_password.dart';

class SupplerLoginScreen extends StatefulWidget {
  const SupplerLoginScreen({super.key});

  @override
  State<SupplerLoginScreen> createState() => _SupplerLoginScreenState();
}

class _SupplerLoginScreenState extends State<SupplerLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> supplierLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    authViewModel.loading(true); // Start loading

    bool loginSuccess = await authViewModel.loginSupplier(
      emailController.text.trim(),
      passController.text.trim(),
    );

    authViewModel.loading(false); // Stop loading

    if (loginSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successfully")),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SupplierDashboardScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Permission denied, invalid supplier credentials")),
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
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text("Sign In",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
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
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()),
                      ),
                      child: const Text("Forgot Password?",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<AuthViewModel>(
                    builder: (context, authViewModel, child) {
                      return authViewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: "Sign In",
                              onPressed: () => supplierLogin(context),
                              color: Colors.blue,
                            );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SupplierRegisterScreen()),
                        ),
                        child: const Text("Register",
                            style: TextStyle(color: Colors.blue)),
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
