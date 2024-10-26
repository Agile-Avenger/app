import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                    _buildLogoutButton(),
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
).animate()
  .fadeIn(duration: 600.ms)
  .scale(begin: Offset(0.8, 0.8)), // Corrected line
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
            value: 'Male',
          ),
          SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.email,
            label: 'Email',
            value: 'john.doe@example.com',
          ),
          SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.phone,
            label: 'Phone',
            value: '+1 (555) 123-4567',
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
            value: 'Diabetes',
          ),
          SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Physician',
            value: 'Dr. Smith',
          ),
          SizedBox(height: 15),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Last Visit',
            value: '2024-10-26',
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
    return Container(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Implement logout functionality
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3b82f6),
                  Color(0xFF9333ea),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF3b82f6).withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
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