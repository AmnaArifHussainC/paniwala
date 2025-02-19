import 'package:flutter/material.dart';
import '../../../config/custome_widgets/custome_btn_auth.dart';
import '../../../config/custome_widgets/custome_text_field.dart';
import '../../../config/services/auth_service.dart';
import '../../../config/utils/validators.dart';

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

  bool _isLoading = false;

  // Handle Rider Registration
  Future<void> _registerRider() async {
    setState(() {
      _isLoading = true;
    });

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();
    String cnic = cnicController.text.trim();

    try {
      bool success = await AuthService().registerRider(
        email: email,
        password: password,
        cnic: cnic,
        phone: phone,
        name: name,
        licenseUrl: null, // Optional field, pass null for now
      );

      if (success) {
        // Show success message and navigate to the next screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rider registered successfully!")),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed. Please try again.")),
        );
      }
    } catch (e) {
      print("Error during rider registration: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Register Rider",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
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
                  validator: (value) => ValidationUtils.validateConfirmPassword(
                    passwordController.text,
                    value,
                  ),
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                CustomButton(
                  text: _isLoading ? "Registering..." : "Register Rider",
                  onPressed: _isLoading
                      ? null
                      : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _registerRider(); // Call the registration function
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
