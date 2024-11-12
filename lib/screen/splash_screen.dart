import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/login.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Lottie.asset('images/animation/Animation - 1730959159682.json'),
            ),
          ),
        ],
      ),
      nextScreen: const Login(),
      duration: 4500,
      backgroundColor: Color(0xFFFFE0B2),
    );
  }
}