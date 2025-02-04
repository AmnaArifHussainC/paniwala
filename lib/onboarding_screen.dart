// import 'package:flutter/material.dart';
// import 'package:onboarding_intro_screen/onboarding_screen.dart';
// import 'package:paniwala/choose_account_screen.dart';
//
// class BoardingScreen extends StatelessWidget {
//   const BoardingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return OnBoardingScreen(
//         pages: [
//           // pages
//           OnBoardingModel(
//             image: Image.asset("assets/images/water1.jpg"),
//             title: "Business Chat",
//             body:
//                 "First impressions are everything in business, even in chat service. It’s important to show professionalism and courtesy from the start",
//           ),
//           OnBoardingModel(
//             image: Image.asset("assets/images/water2.jpg"),
//             title: "Business Chat",
//             body:
//                 "First impressions are everything in business, even in chat service. It’s important to show professionalism and courtesy from the start",
//           ),
//           OnBoardingModel(
//             image: Image.asset("assets/images/water3.jpg"),
//             title: "Business Chat",
//             body:
//                 "First impressions are everything in business, even in chat service. It’s important to show professionalism and courtesy from the start",
//           ),
//         ],
//         showPrevNextButton: true,
//         showIndicator: true,
//         backgourndColor: Colors.white,
//         activeDotColor: Colors.blue,
//         deactiveDotColor: Colors.grey,
//         iconColor: Colors.black,
//         leftIcon: Icons.arrow_circle_left_rounded,
//         rightIcon: Icons.arrow_circle_right_rounded,
//         iconSize: 30,
//         onSkip: () {
//           debugPrint("On Skip Called....");
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChooseAccountScreen(),
//               ));
//         });
//   }
// }

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'choose_account_screen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie Animation
                Lottie.asset(
                  'assets/lottie/delivery.json', // Path to your Lottie file
                  width: 300, // Adjust width for responsiveness
                  height: 300, // Adjust height for responsiveness
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                // Title
                const Text(
                  'Welcome to Paniwala!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Description
                const Text(
                  'Get fresh and pure water delivered to your doorstep. \nStart your journey with us today!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Navigation Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseAccountScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
