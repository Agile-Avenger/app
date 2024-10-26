import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/report_data.dart';
import 'package:http/http.dart' as http;

import 'results_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _filePath;
  String? _scanType;
  String? _diseaseType;
  File? _imageFile;
  PlatformFile? _platformFile;
  bool _isLoading = false;
  String? _fileName;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: kIsWeb,
      );

      if (result != null) {
        setState(() {
          _platformFile = result.files.first;
          _fileName = _platformFile!.name;

          if (kIsWeb) {
            _filePath = _fileName;
          } else {
            _filePath = _platformFile!.path;
            _imageFile = File(_filePath!);
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking file: ${e.toString()}');
    }
  }

  void _analyzeImage() async {
    if (_scanType == 'CT scan') {
      setState(() {
        _diseaseType = 'Tuberculosis';
      });
    } else if (_scanType == 'X-ray') {
      setState(() {
        _diseaseType = 'Pneumonia';
      });
    }

    if (_platformFile != null && _scanType != null && _diseaseType != null) {
      setState(() {
        _isLoading = true;
      });

      String url = _scanType == 'X-ray' && _diseaseType == 'Pneumonia'
          ? 'https://flask-app-616464352400.us-central1.run.app/generate-pneumonia-report'
          : 'https://flask-app-616464352400.us-central1.run.app/generate-tb-report';

      try {
        http.MultipartRequest request =
            http.MultipartRequest('POST', Uri.parse(url));

        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file',
              _platformFile!.bytes!,
              filename: _fileName,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('file', _filePath!),
          );
        }

        final response = await request.send();
        final responseData = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final dynamic jsonResult = json.decode(responseData);
          String formattedReport;

          if (_scanType == 'X-ray') {
            if (jsonResult is Map<String, dynamic> &&
                jsonResult.containsKey('report')) {
              formattedReport = _formatXrayReport(jsonResult['report']);
              // Store X-ray report data globally
              ReportData().setReportData(
                imagePath: _filePath ?? _fileName!,
                diseaseType: _diseaseType!,
                analysisResult: formattedReport,
                scanType: _scanType,
                rawData: jsonResult['report'] is Map<String, dynamic>
                    ? jsonResult['report'] as Map<String, dynamic>
                    : {'report': jsonResult['report']},
              );
            } else {
              formattedReport = jsonResult.toString();
              // Store simple report format
              ReportData().setReportData(
                imagePath: _filePath ?? _fileName!,
                diseaseType: _diseaseType!,
                analysisResult: formattedReport,
                scanType: _scanType,
                rawData: {'report': jsonResult},
              );
            }
          } else {
            if (jsonResult is Map<String, dynamic> &&
                jsonResult.containsKey('report')) {
              formattedReport =
                  _formatCTReport(jsonResult['report'] as Map<String, dynamic>);
              // Store CT report data globally (already implemented)
              ReportData().setReportData(
                imagePath: _filePath ?? _fileName!,
                diseaseType: _diseaseType!,
                analysisResult: formattedReport,
                scanType: _scanType,
                rawData: jsonResult['report'] as Map<String, dynamic>,
              );
            } else {
              _showErrorSnackBar('Invalid response format from server');
              setState(() {
                _isLoading = false;
              });
              return;
            }
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPage(
                imagePath: _filePath ?? _fileName!,
                diseaseType: _diseaseType!,
                analysisResult: formattedReport,
              ),
            ),
          );
        } else {
          _showErrorSnackBar(
              'Error in analyzing image. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error details: $e');
        _showErrorSnackBar('Failed to analyze image: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showErrorSnackBar(
          'Please select an image, scan type, and disease category.');
    }
  }

  String _formatXrayReport(dynamic report) {
    try {
      if (report is String) {
        return report;
      } else if (report is Map<String, dynamic>) {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('X-RAY ANALYSIS REPORT\n');

        // Add basic information if available
        if (report.containsKey('prediction')) {
          buffer.writeln('Prediction: ${report['prediction']}');
        }
        if (report.containsKey('confidence')) {
          buffer.writeln(
              'Confidence: ${(report['confidence'] * 100).toStringAsFixed(2)}%');
        }
        if (report.containsKey('diagnosis')) {
          buffer.writeln('Diagnosis: ${report['diagnosis']}');
        }

        // Add any additional information
        report.forEach((key, value) {
          if (!['prediction', 'confidence', 'diagnosis'].contains(key)) {
            if (value is Map) {
              buffer.writeln('\n${key.toUpperCase()}:');
              value.forEach((k, v) => buffer.writeln('$k: $v'));
            } else if (value is List) {
              buffer.writeln('\n${key.toUpperCase()}:');
              for (var item in value) {
                buffer.writeln('• $item');
              }
            } else {
              buffer.writeln('${key.toUpperCase()}: $value');
            }
          }
        });

        return buffer.toString();
      }
      return 'Unable to format report: Invalid format';
    } catch (e) {
      return 'Error formatting report: $e';
    }
  }

  String _formatCTReport(Map<String, dynamic> report) {
    StringBuffer buffer = StringBuffer();

    // Add patient info
    if (report.containsKey('patient_info')) {
      Map<String, dynamic> patientInfo =
          report['patient_info'] as Map<String, dynamic>;
      buffer.writeln('PATIENT INFORMATION');
      buffer.writeln('Date: ${patientInfo['date']}');
      buffer.writeln('');
    }

    // Add study info
    if (report.containsKey('study')) {
      Map<String, dynamic> study = report['study'] as Map<String, dynamic>;
      buffer.writeln('STUDY DETAILS');
      buffer.writeln('Type: ${study['type']}');
      buffer.writeln('Image Quality: ${study['image_quality']}');
      buffer.writeln('Reason: ${study['reason_for_examination']}');
      buffer.writeln('');
    }

    // Add findings
    if (report.containsKey('findings')) {
      Map<String, dynamic> findings =
          report['findings'] as Map<String, dynamic>;
      buffer.writeln('FINDINGS');
      findings.forEach((key, value) {
        buffer.writeln('${key.replaceAll('_', ' ').toUpperCase()}: $value');
      });
      buffer.writeln('');
    }

    // Add impression
    if (report.containsKey('impression')) {
      buffer.writeln('IMPRESSION');
      buffer.writeln(report['impression']);
      buffer.writeln('');
    }

    // Add recommendations
    if (report.containsKey('recommendations')) {
      buffer.writeln('RECOMMENDATIONS');
      List<dynamic> recommendations =
          report['recommendations'] as List<dynamic>;
      for (var recommendation in recommendations) {
        buffer.writeln('• $recommendation');
      }
    }

    // Add analysis metrics if available
    if (report.containsKey('analysis_metrics')) {
      buffer.writeln('\nANALYSIS METRICS');
      Map<String, dynamic> metrics =
          report['analysis_metrics'] as Map<String, dynamic>;
      metrics.forEach((key, value) {
        buffer.writeln(
            '${key.replaceAll('_', ' ').toUpperCase()}: ${value is double ? value.toStringAsFixed(4) : value}');
      });
    }

    return buffer.toString();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF3b82f6),
      ),
    );
  }

  List<String> getDiseaseOptions() {
    if (_scanType == 'X-ray') {
      return ['Pneumonia'];
    } else if (_scanType == 'CT scan') {
      return ['Tuberculosis'];
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
                                          color: Colors.green,
                                          size: 50,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Selected file: ${_filePath!.split('/').last}',
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          DropdownButton<String>(
                            value: _scanType,
                            hint: const Text('Select scan type'),
                            items: const [
                              DropdownMenuItem(
                                value: 'X-ray',
                                child: Text('X-ray'),
                              ),
                              DropdownMenuItem(
                                value: 'CT scan',
                                child: Text('CT scan'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                _scanType = newValue;
                                _diseaseType = null; // Reset disease type
                              });
                            },
                            dropdownColor: const Color(0xFF1f1f1f),
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          if (_scanType != null) ...[
                            DropdownButton<String>(
                              value: _diseaseType,
                              hint: const Text('Select disease type'),
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
                              dropdownColor: const Color(0xFF1f1f1f),
                              iconEnabledColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _analyzeImage,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                              backgroundColor: const Color(0xFF3b82f6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Analyze Image'),
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
