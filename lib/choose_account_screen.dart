import 'package:flutter/material.dart';

class ChooseAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Name
              Text(
                "Paniwala",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              // Tagline
              Text(
                "Pure Water, Pure Life",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 40), // Add spacing

              // Consumer Card
              AccountTypeCard(
                image: "assets/images/consumer.png",
                title: "Consumer",
                tagline: "Order fresh water anytime",
                onTap: () {
                  Navigator.pushNamed(context, "/consumer_login");
                },
              ),

              SizedBox(height: 20), // Add spacing

              // Supplier Card
              AccountTypeCard(
                image: "assets/images/supplier.png",
                title: "Supplier",
                tagline: "Deliver quality water to customers",
                onTap: () {
                  Navigator.pushNamed(context, "/supplier_login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Account Type Card Widget
class AccountTypeCard extends StatelessWidget {
  final String image;
  final String title;
  final String tagline;
  final VoidCallback onTap;

  const AccountTypeCard({
    required this.image,
    required this.title,
    required this.tagline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Navigate to respective screen
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Image on left
              Image.asset(
                image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),

              SizedBox(width: 20), // Add spacing

              // Text on right
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    tagline,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
