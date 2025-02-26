import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/components/custome_widgets/custome_btn_auth.dart';
import '../../../config/components/custome_widgets/custome_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';

class RiderRegisterScreen extends StatefulWidget {
  @override
  _RiderRegisterScreenState createState() => _RiderRegisterScreenState();
}

class _RiderRegisterScreenState extends State<RiderRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _registerRider(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();
    String cnic = cnicController.text.trim();

    bool success = await authViewModel.registerRider(
      email,
      password,
      cnic,
      phone,
      name,
      null, // No license URL for now
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rider registered successfully!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Register Rider",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.04),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    "Rider Registration",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  textinputtype: TextInputType.text,
                  validator: (value) => ValidationUtils.validateFullName(value),
                  controller: nameController,
                  hintText: "Rider Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  textinputtype: TextInputType.emailAddress,
                  validator: (value) => ValidationUtils.validateEmail(value),
                  controller: emailController,
                  hintText: "Company Email",
                  icon: Icons.email,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  textinputtype: TextInputType.phone,
                  validator: (value) => ValidationUtils.validatePhoneNumber(value),
                  controller: phoneController,
                  hintText: "Phone Number",
                  icon: Icons.phone,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  textinputtype: TextInputType.number,
                  validator: (value) => ValidationUtils.validateCNIC(value),
                  controller: cnicController,
                  hintText: "CNIC (13 digits)",
                  icon: Icons.perm_identity,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  textinputtype: TextInputType.text,
                  validator: (value) => ValidationUtils.validatePassword(value),
                  controller: passwordController,
                  hintText: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  textinputtype: TextInputType.text,
                  validator: (value) => ValidationUtils.validateConfirmPassword(passwordController.text, value),
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                CustomButton(
                  text: authViewModel.isLoading ? "Registering..." : "Register Rider",
                  onPressed: authViewModel.isLoading
                      ? null
                      : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _registerRider(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fix the errors in the form")),
                      );
                    }
                  },
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
