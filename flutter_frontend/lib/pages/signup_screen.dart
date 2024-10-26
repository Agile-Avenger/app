import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print('User registered: ${userCredential.user?.email}');
      Navigator.pop(context); // Go back to the login screen on success
    } catch (e) {
      print('Error: $e');
      // Optionally, show a Snackbar or dialog with the error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: 600, // Set a fixed width for the card
            child: Card(
              elevation: 8, // Add some elevation for shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding inside the card
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Use min size for card height
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started Now',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold, // Smaller font size
                      ),
                    ),
                    SizedBox(height: 16), // Adjust spacing
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    SizedBox(height: 16), // Adjust spacing
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email Address'),
                    ),
                    SizedBox(height: 16), // Adjust spacing
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 16), // Adjust spacing
                    ElevatedButton(
                      onPressed: _register, // Link to register function
                      child: Text('Sign Up'),
                    ),
                    SizedBox(height: 16), // Adjust spacing
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add Google Sign-In functionality here
                      },
                      icon:
                          FaIcon(FontAwesomeIcons.google, color: Colors.white),
                      label: Text('Sign up with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                    SizedBox(height: 16), // Adjust spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? '),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen()), // Navigate to LoginScreen
                            );
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
