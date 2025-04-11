import 'dart:ui';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaia/community.dart';
import 'package:gaia/custom_drawer.dart';
import 'package:gaia/requests.dart';
import 'package:gaia/homepage.dart';
import 'package:gaia/list_page.dart';
import 'package:gaia/theme_provider.dart';
import 'package:provider/provider.dart';

class DamnTime extends StatefulWidget {
  final int initialIndex;

  const DamnTime({super.key, this.initialIndex = 0});

  @override
  _DamnTimeState createState() => _DamnTimeState();
}

class _DamnTimeState extends State<DamnTime> {
  late int _currentIndex;
  late PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
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

  // Get the page title based on the current index
  String _getPageTitle() {
    switch (_currentIndex) {
      case 0:
        return "GAIA'S TOUCH";
      case 1:
        return "NGO LIST";
      case 2:
        return "REQUESTS";
      case 3:
        return "COMMUNITY";
      default:
        return "GAIA'S TOUCH";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final navbarBackgroundColor =
        isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final navbarItemBackgroundColor =
        isDarkMode ? const Color(0xFF262626) : Colors.grey[100];

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(width: 2, color: Colors.teal[400]!),
        ),
        centerTitle: true,
        title: Text(
          _getPageTitle(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontFamily: 'Habibi',
            letterSpacing: 1.2,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: PageView(
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
