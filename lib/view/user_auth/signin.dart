import 'package:flutter/material.dart';
import 'package:paniwala/view/user_auth/register.dart';

import '../../widgets/custome_btn_auth.dart';
import '../../widgets/custome_text_field.dart';

class SignInScreen extends StatelessWidget {
   SignInScreen({super.key});

   final TextEditingController emailcontroller  = TextEditingController();
   final TextEditingController passcontroller = TextEditingController();

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
              "Sign In",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailcontroller,
              hintText: "Email",
              icon: Icons.email,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: passcontroller,
              hintText: "Password",
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Signin",
              onPressed: () {
                debugPrint("Register Pressed");
              },
              color: Colors.blue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?"),
                TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                    },
                    child: Text("Register")
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
