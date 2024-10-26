import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'results_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _filePath;
  String? _scanType;
  String? _diseaseType;
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    String? selectedFilePath =
        await FilePicker.platform.pickFiles().then((result) {
      return result?.files.single.path;
    });

    if (selectedFilePath != null) {
      setState(() {
        _filePath = selectedFilePath;
        _imageFile = File(selectedFilePath);
      });
    }
  }

  void _analyzeImage() async {
    if (_scanType == 'CT scan') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'CT scan analysis is a work in progress. Please try again later.'),
          backgroundColor: Color(0xFF3b82f6),
        ),
      );
      return;
    }

    if (_filePath != null && _scanType != null && _diseaseType != null) {
      setState(() {
        _isLoading = true;
      });

      // Define the URL based on scan and disease types
      String url;
      if (_scanType == 'X-ray' && _diseaseType == 'Pneumonia') {
        url =
            'https://flask-app-616464352400.us-central1.run.app/predict_pneumonia';
      } else if (_scanType == 'X-ray' && _diseaseType == 'Tuberculosis') {
        url = 'https://flask-app-616464352400.us-central1.run.app/predict_tb';
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unsupported scan and disease type combination.'),
            backgroundColor: Color(0xFF3b82f6),
          ),
        );
        return;
      }

      try {
        // Prepare the request
        final request = http.MultipartRequest('POST', Uri.parse(url));
        request.files
            .add(await http.MultipartFile.fromPath('file', _filePath!));

        // Send the request
        final response = await request.send();

        if (response.statusCode == 200) {
  final responseData = await response.stream.bytesToString();
  final jsonResult = json.decode(responseData);

  String analysisResult;

  // Try to handle both old and new response formats
  try {
    if (jsonResult.containsKey('study_info')) {
      // New format
      String classification = jsonResult['study_info']['classification'] ?? 'N/A';
      String confidence = jsonResult['study_info']['confidence']?.toString() ?? 'N/A';
      String confidenceStability = jsonResult['study_info']['confidence_stability']?.toString() ?? 'N/A';
      String findings = jsonResult['findings'] ?? 'N/A';
      String impression = jsonResult['impression'] ?? 'N/A';
      List<String> recommendations = 
          (jsonResult['recommendations'] as List<dynamic>?)?.cast<String>() ?? ['N/A'];

      analysisResult = '''
Classification: $classification
Confidence: $confidence
Stability: $confidenceStability
Findings: $findings
Impression: $impression
Recommendations:
- ${recommendations.join("\n- ")}
''';
    } else if (jsonResult.containsKey('prediction')) {
      // Old format
      List<dynamic> predictions = jsonResult['prediction'][0];
      analysisResult = '''
Normal: ${predictions[0].toStringAsFixed(2)}
${_diseaseType}: ${predictions[1].toStringAsFixed(2)}
''';
    } else {
      throw Exception('Unknown response format');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          imagePath: _filePath!,
          diseaseType: _diseaseType!,
          analysisResult: analysisResult,
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error processing response data. Please try again.'),
        backgroundColor: Color(0xFF3b82f6),
      ),
    );
  }
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Error in analyzing image. Please try again.'),
      backgroundColor: Color(0xFF3b82f6),
    ),
  );
}
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to the server.'),
            backgroundColor: Color(0xFF3b82f6),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Please select an image, scan type, and disease category.'),
        backgroundColor: Color(0xFF3b82f6),
      ));
    }
  }

  List<String> getDiseaseOptions() {
    if (_scanType == 'X-ray') {
      return ['Pneumonia', 'Tuberculosis'];
    } else if (_scanType == 'CT scan') {
      return [
        'COVID-19',
        'Brain Tumor',
        'Skin Cancer',
        'Diabetic Retinopathy',
        'Breast Cancer'
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0a0a0a),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFF3b82f6), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  'assets/scan2.gif'), // Your loading GIF
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Analyzing...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF3b82f6),
                                Color(0xFF9333ea),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'Upload Medical Image',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 24 : 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          GestureDetector(
                            onTap: _pickFile,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xFF3b82f6)),
                              ),
                              child: _filePath == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          size: isSmallScreen ? 40 : 50,
                                          color: Colors.white70,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Click to browse your image',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: isSmallScreen ? 14 : 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF3b82f6),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          '✓ Image selected: ${_filePath!.split('/').last}',
                                          style: const TextStyle(
                                            color: Color(0xFF3b82f6),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              value: _scanType,
                              hint: const Text(
                                'Select Scan Type',
                                style: TextStyle(color: Colors.white70),
                              ),
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.white70),
                              underline: Container(),
                              items: <String>[
                                'X-ray',
                                'CT scan'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _scanType = newValue;
                                  _diseaseType = null;
                                });
                              },
                              dropdownColor: const Color(0xFF1a1a1a),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          if (_scanType != null && _scanType != 'CT scan')
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                value: _diseaseType,
                                hint: const Text(
                                  'Select Disease Category',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white70),
                                underline: Container(),
                                items: getDiseaseOptions()
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _diseaseType = newValue;
                                  });
                                },
                                dropdownColor: const Color(0xFF1a1a1a),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          SizedBox(height: isSmallScreen ? 20 : 24),
                          Container(
                            width: double.infinity,
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
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: _analyzeImage,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 14 : 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Analyze Image',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
