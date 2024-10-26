import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientForm extends StatefulWidget {
  final String email; // Add email parameter
  final String name; // Add name parameter

  PatientForm({required this.email, required this.name});

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();
  final TextEditingController _physicianController = TextEditingController();
  DateTime lastVisit = DateTime.now();
  String gender = 'Male';

  @override
  void initState() {
    super.initState();
    // Pre-fill name and email fields
    _nameController.text = widget.name;
    _emailController.text = widget.email;
  }

  Future<void> _savePatientData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': gender,
          'number': _numberController.text.trim(),
          'medicalHistory': _medicalHistoryController.text.trim(),
          'physician': _physicianController.text.trim(),
          'lastVisit': lastVisit,
        });
        print('Patient data saved successfully!');
        _showSnackbar('Patient data saved successfully!');
        _clearForm();
      } catch (e) {
        print('Error saving patient data: $e');
        _showSnackbar('Error saving patient data: $e');
      }
    } else {
      _showSnackbar('No user is currently logged in.');
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _ageController.clear();
    _numberController.clear();
    _medicalHistoryController.clear();
    _physicianController.clear();
    setState(() {
      gender = 'Male';
      lastVisit = DateTime.now();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) => value == null ||
                      value.isEmpty ||
                      !RegExp(r'\S+@\S+\.\S+').hasMatch(value)
                  ? 'Please enter a valid email'
                  : null,
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your age'
                  : null,
            ),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            TextFormField(
              controller: _numberController,
              decoration: InputDecoration(labelText: 'Contact Number'),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your contact number'
                  : null,
            ),
            TextFormField(
              controller: _medicalHistoryController,
              decoration: InputDecoration(labelText: 'Medical History'),
              maxLines: 3,
            ),
            TextFormField(
              controller: _physicianController,
              decoration: InputDecoration(labelText: 'Physician Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _savePatientData();
                }
              },
              child: Text('Save Patient Data'),
            ),
          ],
        ),
      ),
    );
  }
}
