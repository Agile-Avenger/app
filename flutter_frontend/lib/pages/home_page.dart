import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'upload_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/scanlogo.png', height: 32)
              .animate()
              .fadeIn(duration: 600.ms),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
            ),
          ).animate().fadeIn(duration: 600.ms),
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
        child: Stack(
          children: [
            // Background geometric patterns
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3b82f6).withOpacity(0.1),
                      Color(0xFF9333ea).withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF9333ea).withOpacity(0.1),
                      Color(0xFF3b82f6).withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 80),
                    // Stats cards
                    Row(
                      children: [
                        _buildStatCard(
                          icon: Icons.analytics,
                          title: '99.9%',
                          subtitle: 'Accuracy',
                          delay: 0,
                        ),
                        SizedBox(width: 16),
                        _buildStatCard(
                          icon: Icons.speed,
                          title: '<2s',
                          subtitle: 'Processing',
                          delay: 100,
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    // Main title
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color(0xFF3b82f6),
                          Color(0xFF9333ea),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'AI-Powered\nMedical Image\nAnalysis',
                        style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, duration: 600.ms),
                    SizedBox(height: 24),
                    // Description
                    Text(
                      'Leverage cutting-edge artificial intelligence to analyze medical images and detect potential health conditions with unprecedented accuracy and speed.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: -0.2, duration: 600.ms),
                    SizedBox(height: 40),
                    // Features list
                    _buildFeatureItem(
                      icon: Icons.security,
                      title: 'HIPAA Compliant',
                      delay: 300,
                    ),
                    _buildFeatureItem(
                      icon: Icons.health_and_safety,
                      title: 'FDA Approved',
                      delay: 400,
                    ),
                    _buildFeatureItem(
                      icon: Icons.support_agent,
                      title: '24/7 Support',
                      delay: 500,
                    ),
                    SizedBox(height: 40),
                    // Get Started button
                    Center(
                      child: _buildGradientButton(
                        context: context,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UploadPage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
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
    ).animate().fadeIn(duration: 600.ms, delay: delay.ms).slideY(begin: 0.2, duration: 600.ms);
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required int delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF3b82f6), size: 24),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: delay.ms).slideX(begin: -0.2, duration: 600.ms);
  }

  Widget _buildGradientButton({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3b82f6),
                Color(0xFF9333ea),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF3b82f6).withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 20,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.2, duration: 600.ms);
  }}