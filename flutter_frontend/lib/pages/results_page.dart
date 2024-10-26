import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_frontend/pages/report_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http; // Import for HTTP requests

import 'home_page.dart';

class ResultsPage extends StatefulWidget {
  final dynamic imagePath;
  final dynamic analysisResult;
  final dynamic diseaseType;

  const ResultsPage({
    super.key,
    required this.imagePath,
    required this.diseaseType,
    required this.analysisResult,
  });

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String? _selectedLanguage = 'hi'; // Default language
  String? _translatedResult;
  String? _analysisResult;

  @override
  void initState() {
    super.initState();
    // Initialize _analysisResult with the provided analysis result
    _analysisResult = widget.analysisResult;
  }

  set analysisResult(String? value) {
    setState(() {
      _analysisResult = value;
    });
  }

  final Map<String, String> supportedLanguages = {
    "hi": "Hindi",
    "bn": "Bengali",
    "te": "Telugu",
    "ta": "Tamil",
    "mr": "Marathi",
    "gu": "Gujarati",
    "kn": "Kannada",
    "ml": "Malayalam",
    "pa": "Punjabi",
    "ur": "Urdu"
  };

  Future<void> _translateResult() async {
    if (_selectedLanguage == null) return;

    final response = await http.post(
      Uri.parse(
          'https://flask-app-616464352400.us-central1.run.app/translate-report'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'report': _analysisResult,
        'target_language': _selectedLanguage,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        updateTranslatedResult(jsonDecode(response.body)['translated_report']);
        print(jsonDecode(response.body)['translated_report']);
      });
    } else {
      var message = response.body;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void updateTranslatedResult(String? translatedResult) {
    setState(() {
      _translatedResult = translatedResult;

      // Update _analysisResult based on the translated result logic
      _analysisResult =
          translatedResult; // or some logic to determine the new value
    });
  }

  Future<void> generateAndOpenPDF(BuildContext context) async {
    final reportData = ReportData();
    if (!reportData.hasReportData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No report data available')),
      );
      return;
    }

    try {
      final pdf = pw.Document();

      // Load and process the image
      late final pw.MemoryImage image;
      try {
        if (kIsWeb) {
          // For web, assume the imagePath is a base64 string or handle accordingly
          final imageBytes = await _getWebImageBytes(widget.imagePath!);
          image = pw.MemoryImage(imageBytes);
        } else {
          // For mobile platforms
          final file = File(widget.imagePath!);
          image = pw.MemoryImage(file.readAsBytesSync());
        }
      } catch (e) {
        print('Error loading image: $e');
        // Use a placeholder or skip image if loading fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading image for PDF')),
        );
        return;
      }

      // Get report generation time
      final reportTime = reportData.reportGenerationTime ?? DateTime.now();
      final formattedDate = DateFormat('MMMM d, y').format(reportTime);
      final formattedTime = DateFormat('h:mm a').format(reportTime);

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
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.blue500,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
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
                            style: const pw.TextStyle(color: PdfColors.white),
                          ),
                          pw.Text(
                            formattedTime,
                            style: const pw.TextStyle(color: PdfColors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Study Information
                _buildStudyInfo(reportData),
                pw.SizedBox(height: 20),

                // Image Section
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(10)),
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
                      pw.ClipRRect(
                        horizontalRadius: 10,
                        verticalRadius: 10,
                        child: pw.Image(
                          image,
                          height: 200,
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Analysis Results
                _buildAnalysisResults(reportData),

                if (reportData.analysisMetrics != null) ...[
                  pw.SizedBox(height: 20),
                  _buildAnalysisMetrics(reportData),
                ],

                // Footer
                pw.Spacer(),
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'Generated by Medical Analysis System',
                    style: const pw.TextStyle(
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

      // Save and open the PDF
      final bytes = await pdf.save();

      if (kIsWeb) {
        // For web platform
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.window.open(url, '_blank');
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile platforms
        final output = await getTemporaryDirectory();
        final file = File(
            '${output.path}/medical_analysis_${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);
      }
    } catch (e) {
      print('Error generating PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: ${e.toString()}')),
      );
    }
  }

// Helper function to get image bytes for web platform
  Future<Uint8List> _getWebImageBytes(String imagePath) async {
    // Implement based on how you store images in web
    // This is a placeholder - implement according to your web image storage method
    throw UnimplementedError('Web image loading not implemented');
  }

// Helper function to build study information section
  pw.Widget _buildStudyInfo(ReportData reportData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Study Information',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Scan Type: ${reportData.scanType}'),
          pw.Text('Disease Type: ${reportData.diseaseType}'),
          if (reportData.studyDetails != null) ...[
            ...reportData.studyDetails!.entries.map(
              (entry) => pw.Text('${entry.key}: ${entry.value}'),
            ),
          ],
        ],
      ),
    );
  }

// Helper function to build analysis results section
  pw.Widget _buildAnalysisResults(ReportData reportData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Analysis Results',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            _analysisResult!,
            style: const pw.TextStyle(
              fontSize: 12,
              lineSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

// Helper function to build analysis metrics section
  pw.Widget _buildAnalysisMetrics(ReportData reportData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Analysis Metrics',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...reportData.analysisMetrics!.entries.map(
            (entry) => pw.Text(
              '${entry.key}: ${entry.value is double ? (entry.value as double).toStringAsFixed(4) : entry.value}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
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
                      _buildImageContainer(
                          isSmallScreen, screenSize.width * 0.9),
                      const SizedBox(height: 24),
                      _buildDiagnosisContainer(
                          isSmallScreen, screenSize.width * 0.9),
                      const SizedBox(height: 24),
                      _buildAnalysisContainer(
                          isSmallScreen, screenSize.width * 0.9),
                      const SizedBox(height: 24),
                      _buildButtons(
                          isSmallScreen, screenSize.width * 0.9, context),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildImageContainer(
                          isSmallScreen, screenSize.width * 0.4),
                      const SizedBox(width: 24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildTitle(isSmallScreen),
                          const SizedBox(height: 24),
                          _buildDiagnosisContainer(
                              isSmallScreen, screenSize.width * 0.4),
                          const SizedBox(height: 24),
                          _buildAnalysisContainer(
                              isSmallScreen, screenSize.width * 0.4),
                          const SizedBox(height: 24),
                          _buildButtons(
                              isSmallScreen, screenSize.width * 0.4, context),
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

  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: _selectedLanguage,
      onChanged: (String? newValue) {
        setState(() {
          _selectedLanguage = newValue!;
        });
      },
      items: supportedLanguages.keys
          .map<DropdownMenuItem<String>>((String langCode) {
        return DropdownMenuItem<String>(
          value: langCode,
          child: Text(supportedLanguages[langCode]!),
        );
      }).toList(),
    );
  }

  Widget _buildTranslateButton() {
    return ElevatedButton(
      onPressed: _translateResult,
      child: const Text('Translate'),
    );
  }

  Widget _buildTranslatedResults() {
    return _translatedResult != null
        ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Translated Results',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _translatedResult!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          )
        : Container();
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
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms);
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
          File(widget.imagePath),
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
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.diseaseType,
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
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _analysisResult ?? 'No result available',
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

  Widget _buildButtons(
      bool isSmallScreen, double maxWidth, BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          // Language Dropdown
          // Language Dropdown
          DropdownButton<String>(
            value:
                _selectedLanguage, // Ensure this variable is defined in your state
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
              // Call the translation function when the language changes
              _translateResult();
            },
            items: supportedLanguages.keys
                .map<DropdownMenuItem<String>>((String langCode) {
              return DropdownMenuItem<String>(
                value: langCode,
                child: Text(supportedLanguages[langCode]!),
              );
            }).toList(),
            dropdownColor:
                Colors.black, // Optional: Change dropdown background color
            icon: Icon(Icons.language,
                color: Colors.white), // Optional: Add an icon
            underline: Container(), // Remove underline
          ),
          // Home Button
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
          // Print Results Button
          GestureDetector(
            onTap: () => generateAndOpenPDF(context),
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
