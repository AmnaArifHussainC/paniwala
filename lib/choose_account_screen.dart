import 'package:flutter/material.dart';
import 'package:paniwala/view/user_auth/signin.dart';
import 'package:paniwala/widgets/main_screen_cards.dart';

class ChooseAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Paniwala",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Pure Water, Pure Life",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Subheading
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: const [
                    Text(
                      "Pakistan's #1 Water Delivery App",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Choose your account type",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Account Type Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    Expanded(
                      child: AccountTypeCard(
                        image: "assets/images/consumer.png",
                        title: "Consumer",
                        tagline: "Order fresh water online",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: AccountTypeCard(
                        image: "assets/images/supplier.png",
                        title: "Supplier",
                        tagline: "Register your water business",
                        onTap: () {
                          Navigator.pushNamed(context, "/supplier_login");
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Divider with "or"
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: const Text("or", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              // Login Text
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: const Text(
                    "Already have an account? Log in",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Terms and Policies
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Column(
                  children: [
                    const Text(
                      "By continuing, you agree to our",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Terms of Service",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Privacy Policy",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Content Policies",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
