import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'home_page.dart';

class ResultsPage extends StatelessWidget {
  final String imagePath;
  final String diseaseType;
  final String analysisResult;

  const ResultsPage({
    Key? key,
    required this.imagePath,
    required this.diseaseType,
    required this.analysisResult,
  }) : super(key: key);
  
  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          color: Color(0xFF0a0a0a),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isSmallScreen) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTitle(isSmallScreen),
                      const SizedBox(height: 24),
                      _buildImageContainer(isSmallScreen, screenSize.width * 0.9),
                      const SizedBox(height: 24),
                      _buildDiagnosisContainer(isSmallScreen, screenSize.width * 0.9),
                      const SizedBox(height: 24),
                      _buildAnalysisContainer(isSmallScreen, screenSize.width * 0.9),
                      const SizedBox(height: 24),
                      _buildButtons(isSmallScreen, screenSize.width * 0.9, context),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildImageContainer(isSmallScreen, screenSize.width * 0.4),
                      const SizedBox(width: 24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildTitle(isSmallScreen),
                          const SizedBox(height: 24),
                          _buildDiagnosisContainer(isSmallScreen, screenSize.width * 0.4),
                          const SizedBox(height: 24),
                          _buildAnalysisContainer(isSmallScreen, screenSize.width * 0.4),
                          const SizedBox(height: 24),
                          _buildButtons(isSmallScreen, screenSize.width * 0.4, context),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(bool isSmallScreen) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF3b82f6),
          Color(0xFF9333ea),
        ],
      ).createShader(bounds),
      child: Text(
        'Analysis Results',
        textAlign: isSmallScreen ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontSize: isSmallScreen ? 28.0 : 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, duration: 600.ms);
  }

  Widget _buildImageContainer(bool isSmallScreen, double maxWidth) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: isSmallScreen ? 300 : 400,
        maxWidth: maxWidth,
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
        .slideY(begin: 0.2, duration: 600.ms);
  }

  Widget _buildDiagnosisContainer(bool isSmallScreen, double maxWidth) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
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
        .slideY(begin: 0.2, duration: 600.ms);
  }

  Widget _buildAnalysisContainer(bool isSmallScreen, double maxWidth) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            analysisResult,
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
        .slideY(begin: 0.2, duration: 600.ms);
  }

  Widget _buildButtons(bool isSmallScreen, double maxWidth, BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
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
                    color: const Color(0xFF3b82f6).withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
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
        .slideY(begin: 0.2, duration: 600.ms);
  }
}