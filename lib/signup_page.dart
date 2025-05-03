import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import dart:convert for jsonEncode
import 'package:gaia/login.dart'; // Import LoginPage

// Convert to StatefulWidget
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Add GlobalKey for Form validation
  final _formKey = GlobalKey<FormState>();
  // Add TextEditingControllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // To show loading indicator

  @override
  void dispose() {
    // Dispose controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Signup function
  Future<void> _signup() async {
    // Validate form
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final url = Uri.parse('https://ngo-app-3mvh.onrender.com/api/auth/signup');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        );

        setState(() {
          _isLoading = false; // Stop loading
        });

        if (response.statusCode == 200 || response.statusCode == 201) { // Assuming 201 Created is also success
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup successful!')),
          );
          // Optionally navigate back or to login page
          // Navigator.pop(context); // Go back
          // Navigate to Login Page after successful signup
          if (mounted) { // Check if the widget is still in the tree
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        } else {
          // Show error message based on response
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['message'] ?? 'Signup failed. Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Stop loading on error
        });
        // Show generic error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      // Replace placeholder body with Form
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Show ElevatedButton or loading indicator
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signup, // Call signup function
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
} 