// Reusable Account Type Card Widget
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paniwala/const/colors.dart';

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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(image, width: 80, height: 80),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Text(
                  tagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}