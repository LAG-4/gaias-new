import 'package:flutter/material.dart';
import 'package:gaia/mycontributions.dart';
import 'package:gaia/myrewards.dart';
import 'package:gaia/theme_provider.dart';
import 'package:provider/provider.dart';

// Custom clipper for full-height drawer
class _DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
        child: ListView(
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
                    color: Colors.teal.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
            ListTile(
              leading: const Icon(Icons.volunteer_activism, color: Colors.teal),
              title: Text(
                'My Contributions',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyContributions()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard, color: Colors.teal),
              title: Text(
                'My Reward Points',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyRewards()),
                );
              },
            ),
            Divider(
              color: Colors.teal.withOpacity(0.3),
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.teal,
              ),
              title: Text(
                themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}
