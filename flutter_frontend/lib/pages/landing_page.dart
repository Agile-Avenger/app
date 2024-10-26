import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' show pi, sin;
import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
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
                child: CustomPaint(
                  painter: BackgroundPainter(
                    animation: _controller,
                    color1: Color(0xFF3b82f6).withOpacity(0.1),
                    color2: Color(0xFF9333ea).withOpacity(0.1),
                  ),
                  child: Container(),
                ),
              );
            },
          ),
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 40),
                  // Logo animation
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
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
  padding: const EdgeInsets.all(20.0),
  child: ClipOval(
    child: Image.asset(
      'assets/scanlogo.png',
      width: 120, // Set the desired width
      height: 120, // Set the desired height
      fit: BoxFit.cover, // Ensures the image covers the circular area
      ),
  ),
),
                    ),
                  ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
                  SizedBox(height: 40),
                  // Main title with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color(0xFF3b82f6),
                        Color(0xFF9333ea),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Transform Healthcare\nWith AI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 56.0,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
                  SizedBox(height: 24),
                  // Subtitle
                  Text(
                    'Experience the future of medical diagnostics with our advanced AI-powered image analysis platform.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.3),
                  SizedBox(height: 60),
                  // Stats row
                  _buildStatsRow(),
                  SizedBox(height: 80),
                  // Features grid
                  _buildFeaturesGrid(),
                  SizedBox(height: 80),
                  // Enter button
                  _buildEnterButton(context),
                  SizedBox(height: 60),
                  // Trust indicators
                  _buildTrustIndicators(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          number: '99.9%',
          label: 'Accuracy',
          delay: 0,
        ),
        _buildDivider(),
        _buildStatItem(
          number: '1M+',
          label: 'Scans Analyzed',
          delay: 100,
        ),
        _buildDivider(),
        _buildStatItem(
          number: '24/7',
          label: 'Support',
          delay: 200,
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms);
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildStatItem({
    required String number,
    required String label,
    required int delay,
  }) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        _buildFeatureCard(
          icon: Icons.speed,
          title: 'Real-time Analysis',
          description: 'Get results in seconds',
          delay: 0,
        ),
        _buildFeatureCard(
          icon: Icons.security,
          title: 'HIPAA Compliant',
          description: 'Secure data handling',
          delay: 100,
        ),
        _buildFeatureCard(
          icon: Icons.psychology,
          title: 'Advanced AI',
          description: 'State-of-the-art algorithms',
          delay: 200,
        ),
        _buildFeatureCard(
          icon: Icons.analytics,
          title: 'Detailed Reports',
          description: 'Comprehensive insights',
          delay: 300,
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color(0xFF3b82f6), size: 32),
          SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.020, // Responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.014, // Responsive font size
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ) .animate()
  .fadeIn(duration: Duration(milliseconds: 800), delay: Duration(milliseconds: delay))
  .scale(begin: Offset(0.8, 0.8)); // Use Offset for uniform scalingset
}

  Widget _buildEnterButton(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 800),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3b82f6),
                  Color(0xFF9333ea),
                ],
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF3b82f6).withOpacity(0.3),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter Platform',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 800.ms).slideY(begin: 0.3);
  }

  Widget _buildTrustIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTrustBadge(
          'FDA',
          'Approved',
          delay: 0,
        ),
        SizedBox(width: 40),
        _buildTrustBadge(
          'CE',
          'Certified',
          delay: 100,
        ),
        SizedBox(width: 40),
        _buildTrustBadge(
          'ISO',
          '27001',
          delay: 200,
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms);
  }

  Widget _buildTrustBadge(String title, String subtitle, {required int delay}) {
    return Column(
      children: [
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
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color1;
  final Color color2;

  BackgroundPainter({
    required this.animation,
    required this.color1,
    required this.color2,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final path = Path();

    // Animated wave pattern
    for (var i = 0; i < 5; i++) {
      final phase = animation.value * 2 * pi + i * pi / 2;
      paint.color = i.isEven ? color1 : color2;
      
      path.reset();
      path.moveTo(0, size.height * 0.5);
      
      for (var x = 0; x < size.width; x++) {
        final y = sin(x * 0.01 + phase) * 50 + size.height * 0.5;
        path.lineTo(x.toDouble(), y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}