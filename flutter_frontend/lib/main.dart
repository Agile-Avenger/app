import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const AIMedicalDiagnosisApp());
}

class AIMedicalDiagnosisApp extends StatelessWidget {
  const AIMedicalDiagnosisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Medical Diagnosis',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: GradientText(
          'MediVision AI',
          gradient: const LinearGradient(
            colors: [Color(0xFF3b82f6), Color(0xFF8b5cf6)],
          ),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Home", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UploadPage()),
              );
            },
            child: const Text("Diagnose", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientText(
                'AI-Powered Medical Image Analysis',
                gradient: const LinearGradient(
                  colors: [Color(0xFF3b82f6), Color(0xFF8b5cf6)],
                ),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Leverage cutting-edge artificial intelligence to analyze medical images and detect potential health conditions. Our system provides rapid, accurate insights to support medical professionals.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Container(
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF3b82f6), Color(0xFF8b5cf6)],
    ),
    borderRadius: BorderRadius.circular(30),
  ),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      backgroundColor: Colors.transparent, // Set to transparent
      shadowColor: Colors.transparent, // Remove any shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UploadPage()),
      );
    },
    child: const Text(
      'Get Started',
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? selectedFileName;
  double confidenceScore = 0.0;

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
      });
    }
  }

  void analyzeImage() {
    setState(() {
      confidenceScore = 0.927; // Example score for demonstration
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(fileName: selectedFileName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: GradientText(
          'MediVision AI',
          gradient: const LinearGradient(
            colors: [Color(0xFF3b82f6), Color(0xFF8b5cf6)],
          ),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Home", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Diagnose", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload Medical Image',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectFile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  backgroundColor: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  selectedFileName ?? "Select Image File",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Container(
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF3b82f6), Color(0xFF8b5cf6)],
    ),
    borderRadius: BorderRadius.circular(30),
  ),
              child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      backgroundColor: Colors.transparent, // Set to transparent
      shadowColor: Colors.transparent, // Remove any shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UploadPage()),
      );
    },
    child: const Text(
      'Get Started',
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final String? fileName;

  const ResultsPage({Key? key, this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: GradientText(
          'MediVision AI',
          gradient: const LinearGradient(
            colors: [Color(0xFF3b82f6), Color(0xFF8b5cf6)],
          ),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Home", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Diagnose", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Analysis Results',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    fileName ?? 'Uploaded Image',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  LinearPercentIndicator(
                    lineHeight: 14.0,
                    percent: 0.927,
                    backgroundColor: Colors.grey,
                    progressColor: const Color(0xFF8b5cf6),
                    center: const Text(
                      "92.7% Confidence",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Diagnosis: Lung Cancer',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(this.text, {Key? key, this.style, required this.gradient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(Offset.zero & bounds.size),
      child: Text(text, style: style),
    );
  }
}
