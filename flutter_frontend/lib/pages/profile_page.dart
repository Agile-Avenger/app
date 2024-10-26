import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? patientData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
    try {
      // Retrieve the Firebase auth token
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

      // Prepare the headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token', // Include the token in the headers
        'Content-Type': 'application/json',
      };

      // Make the HTTP request with headers
      final response = await http.get(
        Uri.parse('https://flask-app-616464352400.us-central1.run.app/patient'),
        headers: headers, // Pass the headers here
      );

      if (response.statusCode == 200) {
        setState(() {
          patientData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                // Implement edit profile functionality
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0a0a0a),
              Color(0xFF1a1a1a),
            ],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Loading spinner
            : hasError
                ? const Center(
                    child: Text('Error fetching data',
                        style: TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).padding.top + 20),
                        // Profile Header
                        _buildProfileHeader(),
                        const SizedBox(height: 30),
                        // Quick Stats
                        _buildQuickStats(),
                        const SizedBox(height: 30),
                        // Main Content
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _buildSection(
                                title: 'Personal Information',
                                content: _buildPersonalInfo(),
                              ),
                              const SizedBox(height: 20),
                              _buildSection(
                                title: 'Medical Information',
                                content: _buildMedicalInfo(),
                              ),
                              const SizedBox(height: 30),
                              _buildLogoutButton(),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3b82f6),
                    Color(0xFF9333ea),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1a1a1a),
                  ),
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(
                        'assets/user3.jpg'), // You can update this based on fetched data
                  ),
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: 20),
        Text(
          patientData?['name'] ?? 'John Doe', // Update with fetched data
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        const SizedBox(height: 8),
        Text(
          'Patient ID: ${patientData?['id'] ?? '#12345'}', // Update with fetched data
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard(
            icon: Icons.calendar_today,
            title: '45',
            subtitle: 'Age',
            delay: 400,
          ),
          const SizedBox(width: 15),
          _buildStatCard(
            icon: Icons.assessment,
            title: '3',
            subtitle: 'Reports',
            delay: 500,
          ),
          const SizedBox(width: 15),
          _buildStatCard(
            icon: Icons.medical_services,
            title: '2',
            subtitle: 'Active',
            delay: 600,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required int delay,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF3b82f6), size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: delay.ms).slideY(begin: 0.2);
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.1)),
          content,
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2);
  }

  Widget _buildPersonalInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person,
            label: 'Gender',
            value: patientData?['gender'] ?? 'N/A',
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.email,
            label: 'Email',
            value: patientData?['email'] ?? 'N/A',
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.phone,
            label: 'Phone',
            value: patientData?['phone'] ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.medical_services,
            label: 'Medical History',
            value: patientData?['medicalHistory'] ?? 'N/A',
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Physician',
            value: patientData?['physician'] ?? 'N/A',
          ),
          const SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Last Visit',
            value: patientData?['lastVisit'] ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3b82f6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF3b82f6), size: 20),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Implement logout functionality
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3b82f6),
                  Color(0xFF9333ea),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3b82f6).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 800.ms).slideY(begin: 0.2);
  }
}
