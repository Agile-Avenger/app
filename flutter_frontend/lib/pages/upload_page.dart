import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'results_page.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _filePath;
  String? _diseaseType;
  File? _imageFile;

  Future<void> _pickFile() async {
    // Clean up previous file if it exists
    await _cleanupPreviousFile();
    
    String? selectedFilePath = await FilePicker.platform.pickFiles()?.then((result) {
      return result?.files.single.path;
    });
    
    if (selectedFilePath != null) {
      setState(() {
        _filePath = selectedFilePath;
        _imageFile = File(selectedFilePath);
      });
    }
  }

  Future<void> _cleanupPreviousFile() async {
    if (_imageFile != null && await _imageFile!.exists()) {
      try {
        // Delete the temporary file
        await _imageFile!.delete();
        _imageFile = null;
        _filePath = null;
      } catch (e) {
        debugPrint('Error cleaning up file: $e');
      }
    }
  }

  void _analyzeImage() {
    if (_filePath != null && _diseaseType != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            imagePath: _filePath!,
            diseaseType: _diseaseType!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select an image and disease category.'),
        backgroundColor: Color(0xFF3b82f6),
      ));
    }
  }

  @override
  void dispose() {
    // Clean up resources when widget is disposed
    _cleanupPreviousFile();
    super.dispose();
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
                child: Column(
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
                          border: Border.all(color: const Color(0xFF3b82f6)),
                        ),
                        child: _filePath == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                        value: _diseaseType,
                        hint: const Text(
                          'Select Disease Category',
                          style: TextStyle(color: Colors.white70),
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                        underline: Container(),
                        items: <String>[
                          'Pneumonia',
                          'Tuberculosis',
                          'COVID-19',
                          'Brain Tumor',
                          'Skin Cancer',
                          'Diabetic Retinopathy',
                          'Breast Cancer',
                        ].map<DropdownMenuItem<String>>((String value) {
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
                            color: const Color(0xFF3b82f6).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _analyzeImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Analyze Image',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w600,
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