import 'package:flutter/material.dart';
import 'package:paniwala/const/colors.dart';
import 'package:paniwala/view/rider_auth/rider_login.dart';

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
                  // Subheading
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
                      _buildAccountCard(
                        context,
                        image: "assets/images/companyowner.png",
                        title: "Company Owner",
                        description: "Register your water company",
                        onTap: () => Navigator.pushNamed(context, "/company_owner_login"),
                      ),
                      const SizedBox(height: 20),
                      _buildAccountCard(
                        context,
                        image: "assets/images/rider.png",
                        title: "Rider",
                        description: "Join as a water delivery rider",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RiderSignInScreen()),
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

  Widget _buildAccountCard(BuildContext context, {
    required String image,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        color: AppColors.aliceBlue,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image
              Image.asset(
                image,
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
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
