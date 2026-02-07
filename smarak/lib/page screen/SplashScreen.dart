import 'package:flutter/material.dart';
import 'package:smarak/page%20screen/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  final Function(bool)? onThemeChange;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    this.onThemeChange,
    this.isDarkMode = false,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardingPage(
            onThemeChange: widget.onThemeChange,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/gif/1.gif',
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}
