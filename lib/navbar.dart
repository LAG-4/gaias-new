import 'dart:ui';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaia/community.dart';
import 'package:gaia/requests.dart';
import 'package:gaia/homepage.dart';
import 'package:gaia/list_page.dart';
import 'package:gaia/theme_provider.dart';
import 'package:provider/provider.dart';

class DamnTime extends StatefulWidget {
  const DamnTime({super.key});

  @override
  _DamnTimeState createState() => _DamnTimeState();
}

class _DamnTimeState extends State<DamnTime> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Custom icons and colors for navbar
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.volunteer_activism_rounded,
    Icons.campaign_rounded,
    Icons.groups_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final navbarBackgroundColor =
        isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final navbarItemBackgroundColor =
        isDarkMode ? const Color(0xFF262626) : Colors.grey[100];

    return Scaffold(
      extendBody: true,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomePage(),
            ListPage(),
            RequestPage(),
            CommunityPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navbarBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: navbarItemBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return _buildNavItem(index);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build individual navigation items
  Widget _buildNavItem(int index) {
    final isSelected = index == _currentIndex;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        setState(() => _currentIndex = index);
        _pageController.jumpToPage(index);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 40,
        width: 64,
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              _icons[index],
              color: isSelected
                  ? Colors.teal[400]
                  : isDarkMode
                      ? Colors.white
                      : Colors.black54,
              size: 24,
            ),
            if (isSelected)
              Positioned(
                bottom: 6,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.teal[400],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
