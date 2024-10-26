import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class PatientForm extends StatefulWidget {
  final String userEmail;
  final String userName;

  const PatientForm(
      {super.key, required this.userEmail, required this.userName});

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String email;
  int age = 0;
  String gender = 'Male';
  String number = '';
  String medicalHistory = '';
  String physician = '';
  DateTime lastVisit = DateTime.now();
  List<String> symptoms = [];

  @override
  void initState() {
    super.initState();
    name = widget.userName;
    email = widget.userEmail;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare the data to be sent to the backend
      final Map<String, dynamic> formData = {
        'name': name,
        'age': age,
        'gender': gender,
        'referring_physician': physician,
        'medical_history': medicalHistory,
        'symptoms': symptoms,
      };

      try {
        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Get the ID token
          String? idToken = await user.getIdToken();

          // Convert the data to JSON
          final String jsonData = json.encode(formData);

          // Send the data to the backend
          final http.Response response = await http.post(
            Uri.parse(
                'https://flask-app-616464352400.us-central1.run.app/add_patient'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'Bearer $idToken', // Add the token to the headers
            },
            body: jsonData,
          );

          // Check the response status
          if (response.statusCode == 201) {
            // If the server returns a 201 CREATED response, navigate to the HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            // If the server did not return a 201 CREATED response,
            // show an error message or handle the error appropriately
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save data: ${response.body}')),
            );
          }
        } else {
          // If the user is not authenticated, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated')),
          );
        }
      } catch (e) {
        // Handle any errors that occur during the request
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Container(
            width: 800, // Set desired width for the card
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.grey.shade900, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Event Registration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Register with us to get more details.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    initialValue: name,
                    label: 'Name',
                    hint: 'Enter your name',
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter your name'
                        : null,
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    initialValue: email,
                    label: 'Email',
                    hint: 'Enter your email',
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter your email'
                        : null,
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: 'Phone',
                    hint: 'Enter your contact number',
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => number = value,
                  ),
                  const SizedBox(height: 15),
                  _buildDropdown(
                    value: gender,
                    label: 'Gender',
                    items: ['Male', 'Female', 'Other'],
                    onChanged: (value) => setState(() => gender = value!),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: 'Age',
                    hint: 'Enter your age',
                    keyboardType: TextInputType.number,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter your age'
                        : null,
                    onChanged: (value) => age = int.tryParse(value) ?? 0,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: 'Medical History',
                    hint: 'Enter your medical history',
                    maxLines: 3,
                    onChanged: (value) => medicalHistory = value,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: 'Physician',
                    hint: 'Enter your physician\'s name',
                    onChanged: (value) => physician = value,
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: lastVisit,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Colors.tealAccent,
                                onPrimary: Colors.black,
                                surface: Colors.grey.shade800,
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null && pickedDate != lastVisit) {
                        setState(() => lastVisit = pickedDate);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade600),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Last Visit: ${DateFormat('yyyy-MM-dd').format(lastVisit)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: _submitForm,
                    child: const Center(
                      child: Text(
                        'Sign me up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.black,
        ),
      ),
    );
  }
}
