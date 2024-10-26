import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/home_page.dart';
import 'package:intl/intl.dart';

class PatientForm extends StatefulWidget {
  final String userEmail;
  final String userName;

  PatientForm({required this.userEmail, required this.userName});

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

  @override
  void initState() {
    super.initState();
    name = widget.userName;
    email = widget.userEmail;
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
              boxShadow: [
                const BoxShadow(
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
                    child: AbsorbPointer(
                      child: _buildTextField(
                        label: 'Last Visit Date',
                        hint: DateFormat('yyyy-MM-dd').format(lastVisit),
                        onChanged: (String) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150, // Set desired width
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3b82f6),
                            Color(0xFF9333ea),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Navigate to HomePage on successful form validation
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          }
                        },
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
    String? initialValue,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    String? Function(String?)? validator, // Optional validator
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator, // Use the optional validator
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.grey.shade800,
      iconEnabledColor: Colors.white,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
