import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:paniwala/view/authentication/supplier/supplier_login_screen.dart';
import '../../../config/custome_widgets/custome_btn_auth.dart';
import '../../../config/custome_widgets/custome_text_field.dart';
import '../../../config/utils/validators.dart';
import '../../../view_model/auth_viewmodel.dart';

class SupplierRegisterScreen extends StatefulWidget {
  const SupplierRegisterScreen({super.key});

  @override
  _SupplierRegisterScreenState createState() => _SupplierRegisterScreenState();
}

class _SupplierRegisterScreenState extends State<SupplierRegisterScreen> {
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  String? selectedFilePath;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthViewModel authViewModel = AuthViewModel(); // Create a local instance of AuthViewModel

  bool isLoading = false;

  // File picker for uploading PDF
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    }
  }

  // Supplier registration logic
  Future<void> _registerSupplier() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      // Upload file to Cloudinary
      String? certificateUrl;
      if (selectedFilePath != null) {
        certificateUrl = await authViewModel.uploadToCloudinary(selectedFilePath!);
      }

      if (certificateUrl == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload certificate. Please try again.")),
        );
        return;
      }

      // Continue with registration
      final success = await authViewModel.registerSupplier(
        cnic: cnicController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        companyName: companyNameController.text.trim(),
        certificateUrl: certificateUrl, // Save Cloudinary URL
      );

      setState(() {
        isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration request sent successfully.")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SupplerLoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed. Please try again.")),
        );
      }
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
          'Supplier Registration',
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
                  const Center(
                    child: Text(
                      "Register your business",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    textinputtype: TextInputType.number,
                    controller: cnicController,
                    hintText: "CNIC (National Identity)",
                    icon: Icons.card_membership,
                    validator: (value) => ValidationUtils.validateCNIC(value),
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    textinputtype: TextInputType.phone,
                    controller: phoneController,
                    hintText: "Phone Number",
                    icon: Icons.phone,
                    validator: (value) => ValidationUtils.validatePhoneNumber(value),
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    textinputtype: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    validator: (value) => ValidationUtils.validateEmail(value),
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    textinputtype: TextInputType.text,
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) => ValidationUtils.validatePassword(value),
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    textinputtype: TextInputType.text,
                    controller: companyNameController,
                    hintText: "Company Name",
                    icon: Icons.business,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your company name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file, color: Colors.blue),
                    label: Text(
                      selectedFilePath == null
                          ? "Upload PDF Certificate"
                          : "Certificate Uploaded",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                    text: isLoading ? "Requesting..." : "Send Request",
                    onPressed: isLoading ? null : _registerSupplier,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SupplerLoginScreen()),
                          );
                        },
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
