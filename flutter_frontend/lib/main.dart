import 'package:flutter/material.dart';
import './pages/home_page.dart';
import './pages/results_page.dart';
import './pages/upload_page.dart';
import './pages/landing_page.dart';  // Add this import

void main() {
  runApp(MediVisionAI());
}

class MediVisionAI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediVision AI',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,  // Removes the debug banner
      home: LandingPage(),  // Changed from HomePage to LandingPage
    );
  }
}