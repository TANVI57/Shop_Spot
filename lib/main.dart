import 'package:flutter/material.dart';
// FIX: Use package: followed by your project name instead of 'lib/...'
import 'presentation/screens/splash_screen.dart';

void main() async {
  // Ensures plugin services are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Spot',
      home: const OnboardingScreen1(),
    );
  }
}
