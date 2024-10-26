import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

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

  Future<void> _generateAndOpenPDF(BuildContext context) async {
    final pdf = pw.Document();
    
    // Load the image
    final image = pw.MemoryImage(
      File(imagePath).readAsBytesSync(),
    );

    // Get current date and time
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM d, y').format(now);
    final formattedTime = DateFormat('h:mm a').format(now);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [
                      PdfColor.fromHex('3b82f6'),
                      PdfColor.fromHex('9333ea'),
                    ],
                  ),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Medical Analysis Report',
                      style: pw.TextStyle(
                        fontSize: 24,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          formattedDate,
                          style: pw.TextStyle(color: PdfColors.white),
                        ),
                        pw.Text(
                          formattedTime,
                          style: pw.TextStyle(color: PdfColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Image Section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Analyzed Image',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Image(image, height: 200),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Diagnosis Section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Diagnosis',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(diseaseType),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Analysis Results Section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Analysis Details',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(analysisResult),
                  ],
                ),
              ),

              // Footer
              pw.Spacer(),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Generated by Medical Analysis System',
                  style: pw.TextStyle(
                    color: PdfColors.grey600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/medical_analysis_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF
    await OpenFile.open(file.path);
  }

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
            onTap: () => _generateAndOpenPDF(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 24 : 30,
                vertical: isSmallScreen ? 12 : 15,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.print_rounded,
                    color: Colors.white,
                    size: isSmallScreen ? 18 : 20,
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 10),
                  Text(
                    'Print Results',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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