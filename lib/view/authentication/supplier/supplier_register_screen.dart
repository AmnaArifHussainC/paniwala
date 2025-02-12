import 'package:flutter/material.dart';
import 'package:paniwala/view/authentication/supplier/supplier_login_screen.dart';
import '../../../config/custome_widgets/custome_btn_auth.dart';
import '../../../config/custome_widgets/custome_text_field.dart';
import '../../../config/utils/validators.dart';

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
  final TextEditingController filterCertificateController = TextEditingController();

  String? selectedFilePath;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
                  const SizedBox(height: 10),



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
                    textinputtype: TextInputType.text, // Ensure this is present
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
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    onPressed: (){},
                    icon: const Icon(Icons.upload_file, color: Colors.blue),
                    label: const Text(
                      "Upload PDF Certificate",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),

                  if (selectedFilePath != null)
                    TextButton(
                      onPressed: (){},
                      child: const Text(
                        "Open Selected File",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                  const SizedBox(height: 20),

                  CustomButton(
                    text: "Register Supplier",
                    onPressed: (){},
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
