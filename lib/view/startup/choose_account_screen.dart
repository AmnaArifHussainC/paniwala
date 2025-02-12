import 'package:flutter/material.dart';

import '../../config/custome_widgets/choose_screen_cards.dart';
import '../../view_model/auth_viewmodel.dart';
import '../../view_model/auth_viewmodel.dart';
import '../authentication/consumer/consumer_register.dart';
import 'choose_supplier_rider-screen.dart';

class ChooseAccountScreen extends StatelessWidget {
  const ChooseAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Paniwala",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Choose your account type",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Account Type Buttons
                  Column(
                    children: [
                      AccountCard(
                          image: "assets/images/consumer.png",
                          title: "Consumer",
                          description: "Order fresh water online",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen(
                                          authViewModel: AuthViewModel(),
                                        )));
                          }),
                      const SizedBox(height: 20),
                      AccountCard(
                        image: "assets/images/supplier.png",
                        title: "Supplier",
                        description: "Register your water business",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseSupplierTypeScreen()));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  //
                  // GestureDetector(
                  //   onTap: (){},
                  //   child: const Text(
                  //     "Already have an account? Log in",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.blue,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
