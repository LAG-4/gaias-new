import 'package:flutter/material.dart';
import 'package:gaia/homepage.dart';
import 'package:gaia/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shadowAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _shadowAnimation =
        Tween<double>(begin: 0.3, end: 0.7).animate(_animationController);

    // Start animation after a short delay
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _isExpanded = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.teal,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutQuart,
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
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "GAIA'S",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
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
                              Text(
                                'TOUCH',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
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
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset('assets/img.png'),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _isExpanded ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.teal[300]!,
                          Colors.teal[400]!,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon:
                              const Icon(Icons.g_mobiledata_rounded, size: 30),
                          color: Colors.black,
                        ),
                        TextButton(
                          child: const Text(
                            'Sign in With Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DamnTime()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
