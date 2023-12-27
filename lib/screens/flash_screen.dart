import 'package:flutter/material.dart';
import 'package:tripinsider/utils/colorsScheme.dart';

class FlashScreen extends StatelessWidget {
  const FlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Center(
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/TripInsiderLogo.png',
                ),
                fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
