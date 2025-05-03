import 'package:flutter/material.dart';
import 'package:gaia/mycontributions.dart';
import 'package:gaia/myrewards.dart';
import 'package:gaia/theme_provider.dart';
import 'package:gaia/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Custom clipper for full-height drawer
class _DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _drawerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _drawerAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuint,
    );

    // Start animation when drawer opens
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ClipPath(
      clipper: _DrawerClipper(),
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.85,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        child: AnimatedBuilder(
            animation: _drawerAnimation,
            builder: (context, child) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal
                              .withOpacity(0.3 * _drawerAnimation.value),
                          spreadRadius: 1,
                          blurRadius: 10 * _drawerAnimation.value,
                          offset: Offset(0, 4 * _drawerAnimation.value),
                        ),
                      ],
                    ),
                    child: FadeTransition(
                      opacity: _drawerAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-0.3, 0),
                          end: Offset.zero,
                        ).animate(_drawerAnimation),
                        child: const Text(
                          'Welcome, LAG',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildAnimatedListTile(
                    icon: Icons.volunteer_activism,
                    title: 'My Contributions',
                    delay: 0.2,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, animation, secondaryAnimation) =>
                              const MyContributions(),
                          transitionsBuilder:
                              (_, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  _buildAnimatedListTile(
                    icon: Icons.card_giftcard,
                    title: 'My Reward Points',
                    delay: 0.3,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, animation, secondaryAnimation) =>
                              const MyRewards(),
                          transitionsBuilder:
                              (_, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: Interval(0.4, 1.0, curve: Curves.easeOut),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-0.3, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Interval(0.4, 1.0, curve: Curves.easeOut),
                        ),
                      ),
                      child: Divider(
                        color: Colors.teal.withOpacity(0.3),
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ),
                  ),
                  _buildAnimatedListTile(
                    icon: themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    title:
                        themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                    delay: 0.5,
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (_) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: Colors.teal,
                      activeTrackColor: Colors.teal.withOpacity(0.3),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.3),
                    ),
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                  _buildAnimatedListTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    delay: 0.6,
                    onTap: () async {
                      print('Logout tapped');
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('auth_token');

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const WelcomePage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required double delay,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
          ),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.teal),
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontFamily: 'Inter',
            ),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
