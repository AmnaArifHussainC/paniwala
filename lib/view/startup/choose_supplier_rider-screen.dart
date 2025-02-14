import 'package:flutter/material.dart';
import 'package:paniwala/view/authentication/supplier/supplier_login_screen.dart';

import '../../config/custome_widgets/choose_screen_cards.dart';
import '../authentication/rider/rider_login_scree.dart';
import '../authentication/supplier/supplier_register_screen.dart';

class ChooseSupplierTypeScreen extends StatelessWidget {
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
                    "Choose Supplier Type",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Supplier Type Buttons
                  Column(
                    children: [
                      AccountCard(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SupplerLoginScreen()));
                        },
                        image: "assets/images/companyowner.png",
                        title: "Company Owner",
                        description: "Register your water company",
                      ),
                      const SizedBox(height: 20),
                      AccountCard(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RiderSignInScreen()));
                        },
                        image: "assets/images/rider.png",
                        title: "Rider",
                        description: "Join as a water delivery rider",
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
