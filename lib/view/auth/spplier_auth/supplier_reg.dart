import 'package:flutter/material.dart';
import 'package:paniwala/widgets/custome_btn_auth.dart';
import 'package:paniwala/widgets/custome_text_field.dart';
import 'package:paniwala/view/auth/spplier_auth/suppler_login.dart';
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

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  // void openFile(PlatformFile file){
  // OpenFile.open(file.path);
  // }
  // Function to pick PDF file
  // Future<void> pickFile() async {
  //  final result = await FilePicker.platform.pickFiles();
  //  if(result == null) return;
  // //  open single file
  //   final file = result.files.first;
  //   openFile(file);
  // //   openfile (file)
  //   print("Name: ${file.name}");
  //  print("Byte: ${file.bytes}");
  //  print("Size: ${file.size}");
  //  print("Extention: ${file.extension}");
  //  print("Path: ${file.path}");
  // }

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
                  // Centered Title
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

                  // CNIC Field
                  CustomTextField(
                    controller: cnicController,
                    hintText: "CNIC (National Identity)",
                    icon: Icons.card_membership,
                    validator: (value) => ValidationUtils.validateEmail(value),

                  ),
                  const SizedBox(height: 10),

                  // Phone Number Field
                  CustomTextField(
                    controller: phoneController,
                    hintText: "Phone Number",
                    icon: Icons.phone,
                    validator: (value) => ValidationUtils.validateEmail(value),

                  ),
                  const SizedBox(height: 10),

                  // Email Field
                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    validator: (value) => ValidationUtils.validateEmail(value),

                  ),
                  const SizedBox(height: 10),

                  // Password Field
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) => ValidationUtils.validateEmail(value),

                  ),
                  const SizedBox(height: 10),

                  // Water Filter Certificate Field
                  CustomTextField(
                    controller: filterCertificateController,
                    hintText: "Water Filter Certificate (PDF)",
                    icon: Icons.file_copy,
                    validator: (value) => value == null || value.isEmpty ? 'Please upload a certificate' : null,
                  ),
                  ElevatedButton(
                    onPressed: ()async {
                      // FilePickerResult? result = await FilePicker.platform.pickFiles();
                      // if(result!=null){
                      //   print(result.paths);
                      // }
                    },
                    child: Text("Upload PDF Certificate"),
                  ),
                  const SizedBox(height: 20),

                  // Register Button
                  CustomButton(
                    text: "Register Supplier",
                    onPressed: () {
                      debugPrint("Registering Supplier");
                    },
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),

                  // Navigate to Sign In Screen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SupplerLoginScreen()),
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
