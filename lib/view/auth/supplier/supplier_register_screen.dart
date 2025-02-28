import 'package:flutter/material.dart';
import 'package:paniwala/view/auth/supplier/supplier_login_screen.dart';
import 'package:provider/provider.dart';
import '../../../config/components/custome_widgets/custome_text_field.dart';
import '../../../core/utils/cloudinary.dart';
import '../../../core/utils/file_pick.dart';
import '../../../core/utils/validators.dart';
import '../../../viewModel/auth_provider_viewmodel.dart';

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

  Future<void> _pickFile() async {
    String? filePath = await FilePickerUtil.pickPDF();
    if (filePath != null) {
      setState(() {
        selectedFilePath = filePath;
      });
    }
  }

  Future<void> _registerSupplier(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final cloudinaryService = CloudinaryService();
    String? certificateUrl;

    if (selectedFilePath != null) {
      certificateUrl =
          await cloudinaryService.uploadToCloudinary(selectedFilePath!);
    }

    if (certificateUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to upload certificate. Please try again.")),
      );
      return;
    }

    final success = await authViewModel.registerSupplier(
      emailController.text.trim(),
      passwordController.text.trim(),
      cnicController.text.trim(),
      phoneController.text.trim(),
      companyNameController.text.trim(),
      certificateUrl,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(success
              ? "Registration request sent successfully."
              : "Registration failed. Please try again.")),
    );

    if (success) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SupplerLoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08),
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
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    textinputtype: TextInputType.number,
                    controller: cnicController,
                    hintText: "CNIC (National Identity)",
                    icon: Icons.card_membership,
                    validator: ValidationUtils.validateCNIC,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textinputtype: TextInputType.phone,
                    controller: phoneController,
                    hintText: "Phone Number",
                    icon: Icons.phone,
                    validator: ValidationUtils.validatePhoneNumber,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textinputtype: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    validator: ValidationUtils.validateEmail,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textinputtype: TextInputType.text,
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    validator: ValidationUtils.validatePassword,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textinputtype: TextInputType.text,
                    controller: companyNameController,
                    hintText: "Company Name",
                    icon: Icons.business,
                    validator: (value) => value?.isEmpty ?? true
                        ? "Please enter your company name"
                        : null,
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
                  Consumer<AuthViewModel>(
                    builder: (context, authViewModel, child) {
                      return ElevatedButton(
                        onPressed: authViewModel.isLoading
                            ? null
                            : () => _registerSupplier(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: Text(
                          authViewModel.isLoading
                              ? "Requesting..."
                              : "Send Request",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SupplerLoginScreen()),
                        ),
                        child: const Text("Login",
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
