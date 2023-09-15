import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gridapp/screens/InputScreen.dart';

  
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/mobigic_logo.svg',
            width: 50,
            height: 50,
          ),
        ],
      ),
      nextScreen: InputScreen(), // Define the next screen to navigate to
      splashTransition: SplashTransition.fadeTransition,
      duration: 3000, // Set the duration of the splash screen
    );
  }
}