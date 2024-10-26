import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_frontend/pages/login_screen.dart';

class ProfilePage extends StatelessWidget {
  // Example user data; in a real app, this could come from a database
  final String? gender;
  final String? email;
  final String? phone;
  final String? medicalHistory;
  final String? physician;
  final String? lastVisit;

  const ProfilePage({
    Key? key,
    this.gender,
    this.email,
    this.phone,
    this.medicalHistory,
    this.physician,
    this.lastVisit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
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
            margin: EdgeInsets.all(8),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0a0a0a),
              Color(0xFF1a1a1a),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 20),
              // Profile Header
              _buildProfileHeader(),
              SizedBox(height: 30),
              // Quick Stats
              _buildQuickStats(),
              SizedBox(height: 30),
              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildSection(
                      title: 'Personal Information',
                      content: _buildPersonalInfo(),
                    ),
                    SizedBox(height: 20),
                    _buildSection(
                      title: 'Medical Information',
                      content: _buildMedicalInfo(),
                    ),
                    SizedBox(height: 30),
                    _buildLogoutButton(
                        context), // Pass context to logout button
                    SizedBox(height: 30),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3b82f6),
                    Color(0xFF9333ea),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1a1a1a),
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('assets/user3.jpg'),
                  ),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms).scale(begin: Offset(0.8, 0.8)),
        SizedBox(height: 20),
        Text(
          'John Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        SizedBox(height: 8),
        Text(
          'Patient ID: #12345',
          style: TextStyle(
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
          SizedBox(width: 15),
          _buildStatCard(
            icon: Icons.assessment,
            title: '3',
            subtitle: 'Reports',
            delay: 500,
          ),
          SizedBox(width: 15),
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
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFF3b82f6), size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
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
            padding: EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
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
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person,
            label: 'Gender',
            value: gender ?? 'None', // Show "None" if gender is null
          ),
          SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.email,
            label: 'Email',
            value: email ?? 'None', // Show "None" if email is null
          ),
          SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.phone,
            label: 'Phone',
            value: phone ?? 'None', // Show "None" if phone is null
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfo() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.medical_services,
            label: 'Medical History',
            value: medicalHistory ??
                'None', // Show "None" if medical history is null
          ),
          SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Physician',
            value: physician ?? 'None', // Show "None" if physician is null
          ),
          SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Last Visit',
            value: lastVisit ?? 'None', // Show "None" if last visit is null
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
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF3b82f6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Color(0xFF3b82f6), size: 20),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Text('Logout'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF3b82f6),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
