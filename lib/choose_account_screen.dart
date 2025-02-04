import 'package:flutter/material.dart';
import 'package:paniwala/view/user_auth/signin.dart';
import 'package:paniwala/widgets/main_screen_cards.dart';

class ChooseAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Red Section with App Name & Tagline
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 90),
              color: Colors.blue,
              child: Column(
                children: [
                  Text(
                    "Paniwala",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Pure Water, Pure Life",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),


            Text(
              "Pakistan's #1 Water Delivery App",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 10),

            // Choose Account Type
            Text(
              "Choose your account type",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            SizedBox(height: 20),

            // Consumer & Supplier Options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Consumer Card
                  AccountTypeCard(
                    image: "assets/images/consumer.png",
                    title: "Consumer",
                    tagline: "Order fresh water online",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
                    },
                  ),

                  SizedBox(width: 20),

                  // Supplier Card
                  AccountTypeCard(
                    image: "assets/images/supplier.png",
                    title: "Supplier",
                    tagline: "Register your water business",
                    onTap: () {
                      Navigator.pushNamed(context, "/supplier_login");
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // OR Divider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("or"),
                ),
                Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
              ],
            ),

            SizedBox(height: 10),

            // Login Text
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Text(
                "Already have an account? Log in",
                style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),

            Spacer(),

            // Terms and Policies
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text(
                    "By continuing you agree to our",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: () {}, child: Text("Terms of Service",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      )
                      ),
                      TextButton(onPressed: () {}, child: Text("Privacy Policy",
                        style: TextStyle(
                          color: Colors.blue,
                        ),)),
                      TextButton(onPressed: () {}, child: Text("Content Policies",
                        style: TextStyle(
                          color: Colors.blue,
                        ),)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


