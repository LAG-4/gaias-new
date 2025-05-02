import 'package:flutter/material.dart';
import 'package:gaia/homepage.dart';
import 'package:gaia/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shadowAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _shadowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isExpanded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://ngo-app-3mvh.onrender.com/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];

        print('Login successful! Token: $token');

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DamnTime()),
          );
        }
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'Login failed. Please check your credentials.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
        print('Login failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      print('Error during login: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutQuint,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(20 * (1.0 - value), 0),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: RotationTransition(
                        turns: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    key: ValueKey<bool>(isDarkMode),
                    color: Colors.teal,
                  ),
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.elasticOut,
                        height: 150,
                        width: _isExpanded ? 300 : 0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.teal[300]!,
                              Colors.teal[400]!,
                              Colors.teal[600]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal
                                  .withOpacity(_shadowAnimation.value),
                              spreadRadius: 1,
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.teal
                                  .withOpacity(_shadowAnimation.value * 0.4),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(-6, -2),
                            ),
                          ],
                        ),
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "GAIA'S",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 34,
                                    fontFamily: 'Habibi',
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(50, 0, 0, 0),
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'TOUCH',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 34,
                                    fontFamily: 'Habibi',
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(50, 0, 0, 0),
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 30),
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10.0),
                      child: Image.asset(
                        'assets/img.png',
                        fit: BoxFit.contain,
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ),
                  );
                },
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutQuart,
                opacity: _isExpanded ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor?.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutQuart,
                opacity: _isExpanded ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor?.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutQuart,
                opacity: _isExpanded ? 1.0 : 0.0,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutQuart,
                  padding: EdgeInsets.only(
                    top: _isExpanded ? 20 : 100,
                    left: 40,
                    right: 40,
                  ),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.teal[400]!,
                                Colors.teal[600]!,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              splashColor: Colors.white.withOpacity(0.2),
                              highlightColor: Colors.transparent,
                              onTap: _isLoading ? null : _loginUser,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 8.0),
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
