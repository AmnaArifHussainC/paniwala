import 'package:flutter/material.dart';
import 'package:onboarding_intro_screen/onboarding_screen.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingScreen(
        pages: [
          // pages
          OnBoardingModel(
            image: Image.asset("assets/images/water1.jpg"),
            title: "Business Chat",
            body:
            "First impressions are everything in business, even in chat service. It’s important to show professionalism and courtesy from the start",
          ),
          OnBoardingModel(
            image: Image.asset("assets/images/water2.jpg"),
            title: "Business Chat",
            body:
            "First impressions are everything in business, even in chat service. It’s important to show professionalism and courtesy from the start",
          ),
          OnBoardingModel(
            image: Image.asset("assets/images/water3.jpg"),
            title: "Business Chat",
            body:
            "First impressions are everything in business, even in chat service. It’s important to show professionalism and courtesy from the start",
          ),
        ],
        showPrevNextButton: true,
        showIndicator: true,
        backgourndColor: Colors.white,
        activeDotColor: Colors.blue,
        deactiveDotColor: Colors.grey,
        iconColor: Colors.black,
        leftIcon: Icons.arrow_circle_left_rounded,
        rightIcon: Icons.arrow_circle_right_rounded,
        iconSize: 30,
        onSkip: (){
          debugPrint("On Skip Called....");
        }

    );
  }
}
