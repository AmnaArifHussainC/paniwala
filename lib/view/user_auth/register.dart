import 'package:flutter/material.dart';
import 'package:paniwala/view/user_auth/signin.dart';
import '../../widgets/custome_btn_auth.dart';
import '../../widgets/custome_text_field.dart';

class RegisterScreen extends StatelessWidget {
   RegisterScreen({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Register",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: fullNameController,
              hintText: "Full Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: emailController,
              hintText: "Email",
              icon: Icons.email,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: passwordController,
              hintText: "Password",
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: "Confirm Password",
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Register",
              onPressed: () {
                debugPrint("Register Pressed");
              },
              color: Colors.blue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
                    },
                    child: Text("Login",
                      style: TextStyle(
                          color: Colors.blue
                      ),)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
