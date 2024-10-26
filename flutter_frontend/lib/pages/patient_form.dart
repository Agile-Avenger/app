import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class PatientForm extends StatefulWidget {
  final String userEmail;
  final String userName;

  // Constructor to accept the user's email and name
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
    name = widget.userName; // Set default name from login
    email = widget.userEmail; // Set default email from login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  name = value;
                },
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onChanged: (value) {
                  age = int.tryParse(value) ?? 0;
                },
              ),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: <String>['Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
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
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
                onChanged: (value) {
                  number = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Medical History'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your medical history';
                  }
                  return null;
                },
                onChanged: (value) {
                  medicalHistory = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Physician'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your physician\'s name';
                  }
                  return null;
                },
                onChanged: (value) {
                  physician = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Visit Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: lastVisit,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != lastVisit) {
                    setState(() {
                      lastVisit = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(lastVisit),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data (e.g., save to database)
                    print(
                        'Name: $name, Email: $email, Age: $age, Gender: $gender, '
                        'Number: $number, Medical History: $medicalHistory, Physician: $physician, '
                        'Last Visit: ${DateFormat('yyyy-MM-dd').format(lastVisit)}');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
