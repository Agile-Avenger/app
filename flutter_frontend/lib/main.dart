import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Make sure you have the correct path
import './pages/home_page.dart';
import './pages/results_page.dart';
import './pages/upload_page.dart';
import './pages/landing_page.dart';  // Add this import


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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