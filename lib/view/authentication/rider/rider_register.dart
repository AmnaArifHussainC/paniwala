import 'package:flutter/material.dart';
import '../../../config/custome_widgets/custome_btn_auth.dart';
import '../../../config/custome_widgets/custome_text_field.dart';
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

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                // Title
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

                // Rider Name
                CustomTextField(
                  textinputtype: TextInputType.text,
                  validator: (value) => ValidationUtils.validateFullName(value),
                  controller: nameController,
                  hintText: "Rider Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),

                // Company Email
                CustomTextField(
                  textinputtype: TextInputType.emailAddress,
                  validator: (value) => ValidationUtils.validateEmail(value),
                  controller: emailController,
                  hintText: "Company Email",
                  icon: Icons.email,
                ),
                const SizedBox(height: 10),

                // Phone Number
                CustomTextField(
                  textinputtype: TextInputType.phone,
                  validator: (value) => ValidationUtils.validatePhoneNumber(value),
                  controller: phoneController,
                  hintText: "Phone Number",
                  icon: Icons.phone,
                ),
                const SizedBox(height: 10),

                // Password
                CustomTextField(
                  textinputtype: TextInputType.text,
                  validator: (value) => ValidationUtils.validatePassword(value),
                  controller: passwordController,
                  hintText: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Confirm Password
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

                // Register Button
                CustomButton(
                  text: "Register Rider",
                  onPressed: () {

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
