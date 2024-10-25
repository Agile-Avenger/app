import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'home_page.dart';

class ResultsPage extends StatelessWidget {
  final String imagePath;
  final String diseaseType;
  final String analysisResult; // New parameter for the analysis result

  const ResultsPage({
    Key? key,
    required this.imagePath,
    required this.diseaseType,
    required this.analysisResult, // Include the new parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    // Calculate responsive widths
    final contentWidth =
        isSmallScreen ? screenSize.width * 0.9 : screenSize.width * 0.7;
    final maxContentWidth = 800.0;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          color: Color(0xFF0a0a0a),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: contentWidth > maxContentWidth
                  ? maxContentWidth
                  : contentWidth,
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF3b82f6),
                        Color(0xFF9333ea),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Analysis Results',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 28.0 : 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, duration: 600.ms),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Image Container
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: isSmallScreen ? 300 : 400,
                      maxWidth: isSmallScreen ? contentWidth : 600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3b82f6).withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.2, duration: 600.ms),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Diagnosis Text
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: isSmallScreen ? contentWidth : 600,
                    ),
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Diagnosis',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 22 : 24,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Color(0xFF3b82f6),
                                  Color(0xFF9333ea),
                                ],
                              ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          diseaseType,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms)
                      .slideY(begin: 0.2, duration: 600.ms),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Analysis Result Text
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: isSmallScreen ? contentWidth : 600,
                    ),
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Analysis Result',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 22 : 24,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Color(0xFF3b82f6),
                                  Color(0xFF9333ea),
                                ],
                              ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          analysisResult, // Display the analysis result here
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 600.ms)
                      .slideY(begin: 0.2, duration: 600.ms),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Buttons
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: isSmallScreen ? contentWidth : 600,
                    ),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        // Home Button
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 24 : 30,
                              vertical: isSmallScreen ? 12 : 15,
                            ),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // Analyze Another Button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF3b82f6),
                                  Color(0xFF9333ea),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF3b82f6).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 24 : 30,
                              vertical: isSmallScreen ? 12 : 15,
                            ),
                            child: Text(
                              'Analyze Another',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 800.ms)
                      .slideY(begin: 0.2, duration: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
