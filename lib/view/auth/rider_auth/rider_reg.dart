import 'package:flutter/material.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';
import '../../../services/auth/rider_auth.dart';
import '../../../utils/auth_validation/validations.dart';

class RiderRegisterScreen extends StatefulWidget {
  @override
  _RiderRegisterScreenState createState() => _RiderRegisterScreenState();
}

class _RiderRegisterScreenState extends State<RiderRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController deliveryAreaController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _registerRider(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      RiderAuthService authService = RiderAuthService();

      String? result = await authService.registerRider(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        phone: phoneController.text.trim(),
        deliveryArea: deliveryAreaController.text.trim(),
        commission: commissionController.text.trim(),
      );

      if (result == "Rider registered successfully") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rider registered successfully!")),
        );
        Navigator.pop(context); // Navigate back or to another screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result ?? "An error occurred")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in valid details")),
      );
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
                  validator: (value) => ValidationUtils.validateFullName(value),
                  controller: nameController,
                  hintText: "Rider Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),

                // Company Email
                CustomTextField(
                  validator: (value) => ValidationUtils.validateEmail(value),
                  controller: emailController,
                  hintText: "Company Email",
                  icon: Icons.email,
                ),
                const SizedBox(height: 10),

                // Phone Number
                CustomTextField(
                  validator: (value) => ValidationUtils.validatePhoneNumber(value),
                  controller: phoneController,
                  hintText: "Phone Number",
                  icon: Icons.phone,
                ),
                const SizedBox(height: 10),

                // Password
                CustomTextField(
                  validator: (value) => ValidationUtils.validatePassword(value),
                  controller: passwordController,
                  hintText: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Confirm Password
                CustomTextField(
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

                // Maximum Delivery Area
                CustomTextField(
                  validator: (value) => ValidationUtils.validateDeliveryArea(value),
                  controller: deliveryAreaController,
                  hintText: "Maximum Delivery Area (e.g., 10 KM)",
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 10),

                // Commission Percentage
                CustomTextField(
                  validator: (value) => ValidationUtils.validateCommission(value),
                  controller: commissionController,
                  hintText: "Commission (%)",
                  icon: Icons.monetization_on,
                ),
                const SizedBox(height: 20),

                // Register Button
                CustomButton(
                  text: "Register Rider",
                  onPressed: () {
                    _registerRider(context);
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
