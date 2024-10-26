import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: ${e.toString()}'),
          backgroundColor: const Color(0xFF3b82f6),
        ),
      );
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
        http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

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
        
        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final jsonResult = json.decode(responseData);

          if (jsonResult.containsKey('report')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsPage(
                  imagePath: _filePath ?? _fileName!,
                  diseaseType: _diseaseType!,
                  analysisResult: jsonResult['report'],
                ),
              ),
            );
          } else {
            _showErrorSnackBar('Invalid response format from server');
          }
        } else {
          _showErrorSnackBar('Error in analyzing image. Please try again.');
        }
      } catch (e) {
        _showErrorSnackBar('Failed to connect to the server: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showErrorSnackBar('Please select an image, scan type, and disease category.');
    }
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
                              padding: EdgeInsets.all(isSmallScreen ? 16 : 20), backgroundColor: const Color(0xFF3b82f6),
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
