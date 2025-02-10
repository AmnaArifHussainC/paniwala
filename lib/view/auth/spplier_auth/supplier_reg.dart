import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:paniwala/view/supplier_screen/supplier_dash_screen.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';
import 'package:paniwala/view/auth/spplier_auth/suppler_login.dart';
import '../../../services/auth/supplier_auth.dart';
import '../../../utils/auth_validation/validations.dart';

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
  final TextEditingController filterCertificateController = TextEditingController();

  String? selectedFilePath; // Store the selected file path
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to pick a PDF file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      String filePath = result.files.first.path!;
      String fileExtension = filePath.split('.').last.toLowerCase();

      if (fileExtension == 'pdf') {
        setState(() {
          selectedFilePath = filePath;
          filterCertificateController.text = result.files.first.name; // Show file name in text field
        });
      } else {
        // Show error if a non-PDF file is selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a valid PDF file"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to upload a file to Firebase
  Future<String?> uploadFileToFirebase(String filePath, String fileName) async {
    try {
      print("Starting upload for file: $filePath"); // Log file path
      File file = File(filePath);

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/certificates/$fileName');

      TaskSnapshot snapshot = await storageRef.putFile(file);

      if (snapshot.state == TaskState.success) {
        String downloadURL = await snapshot.ref.getDownloadURL();
        print("File uploaded successfully. Download URL: $downloadURL");
        return downloadURL;
      } else {
        print("File upload failed: ${snapshot.state}");
        return null;
      }
    } catch (e) {
      print("Error during file upload: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error uploading file: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  // Function to open the selected file
  void openSelectedFile() {
    if (selectedFilePath != null) {
      OpenFile.open(selectedFilePath);
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
                    controller: cnicController,
                    hintText: "CNIC (National Identity)",
                    icon: Icons.card_membership,
                    validator: (value) => ValidationUtils.validateCNIC(value),
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: phoneController,
                    hintText: "Phone Number",
                    icon: Icons.phone,
                    validator: (value) => ValidationUtils.validatePhoneNumber(value),
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    validator: (value) => ValidationUtils.validateEmail(value),
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) => ValidationUtils.validatePassword(value),
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: filterCertificateController,
                    hintText: "Water Filter Certificate (PDF)",
                    icon: Icons.file_copy,
                    validator: (value) => ValidationUtils.validatePDFUpload(value),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    onPressed: pickFile,
                    icon: const Icon(Icons.upload_file, color: Colors.blue),
                    label: const Text(
                      "Upload PDF Certificate",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),

                  if (selectedFilePath != null)
                    TextButton(
                      onPressed: openSelectedFile,
                      child: const Text(
                        "Open Selected File",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                  const SizedBox(height: 20),

                  CustomButton(
                    text: "Register Supplier",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final authService = SupplierAuthService();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        String? uploadedFileURL;
                        if (selectedFilePath != null) {
                          uploadedFileURL = await uploadFileToFirebase(
                            selectedFilePath!,
                            filterCertificateController.text.trim(),
                          );

                          if (uploadedFileURL == null) {
                            Navigator.of(context).pop();
                            return;
                          }
                        }

                        String? result = await authService.registerSupplier(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          cnic: cnicController.text.trim(),
                          phone: phoneController.text.trim(),
                          filterCertificatePath: uploadedFileURL,
                        );

                        Navigator.of(context).pop();

                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Supplier registered successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SupplerLoginScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SupplierDashboardScreen()),
                          );
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
