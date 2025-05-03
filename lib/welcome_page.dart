import 'package:flutter/material.dart';
import 'package:gaia/login.dart';
import 'package:gaia/signup_page.dart'; // We'll create this next
import 'dart:async'; // Added for Timer

// Changed to StatefulWidget
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

// Added State class with SingleTickerProviderStateMixin
class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation; // Added for fade effect
  bool _showContent = false; // Added for initial delay

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Adjusted duration
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut, // Using elastic out like login page scale
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn), // Fade in slightly later
      ),
    );

    // Add a small delay before starting the animation
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Make AppBar transparent and remove elevation for a cleaner look with animation
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedOpacity(
          opacity: _showContent ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: const Text("Welcome to Gaia's Touch"),
        ),
      ),
      // Extend body behind AppBar for seamless background
      extendBodyBehindAppBar: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Conditionally show content based on _showContent flag
          child: _showContent
              ? ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Added AnimatedBuilder with Image from LoginPage
                        AnimatedBuilder(
                          animation: _scaleAnimation, // Use existing scale animation
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 10.0),
                                child: Image.asset(
                                  'assets/img.png',
                                  fit: BoxFit.contain,
                                  height: MediaQuery.of(context).size.height *
                                      0.3, // Adjusted height if needed
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40), // Add some space below the image
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text('Login'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              // Optional: Style the signup button differently
                              // backgroundColor: Theme.of(context).colorScheme.secondary,
                              // foregroundColor: Theme.of(context).colorScheme.onSecondary,
                              ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()),
                            );
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(), // Show nothing until ready
        ),
      ),
    );
  }
} 