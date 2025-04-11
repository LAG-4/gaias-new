import 'package:flutter/material.dart';
import 'package:gaia/community.dart';
import 'package:gaia/custom_drawer.dart';
import 'package:gaia/requests.dart';
import 'package:gaia/homepage.dart';
import 'package:gaia/list_page.dart';

class DamnTime extends StatefulWidget {
  final int initialIndex;

  const DamnTime({super.key, this.initialIndex = 0});

  @override
  State<DamnTime> createState() => _DamnTimeState();
}

class _DamnTimeState extends State<DamnTime> with TickerProviderStateMixin {
  late int _currentIndex;
  late PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Animation controllers for tab indicators and icons
  late List<AnimationController> _iconAnimationControllers;
  late AnimationController _indicatorAnimationController;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Initialize animation controllers for each tab
    _iconAnimationControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    // Initialize the selected tab's animation
    _iconAnimationControllers[_currentIndex].value = 1.0;

    // Animation for the indicator dot
    _indicatorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _indicatorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _indicatorAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _indicatorAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _iconAnimationControllers) {
      controller.dispose();
    }
    _indicatorAnimationController.dispose();
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
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            _getPageTitle(),
            key: ValueKey<String>(_getPageTitle()),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontFamily: 'Habibi',
              letterSpacing: 1.2,
            ),
          ),
        ),
        leading: Hero(
          tag: 'menu-icon',
          child: Material(
            color: Colors.transparent,
            child: Builder(
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
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            // Update animations when page changes
            _iconAnimationControllers[_currentIndex].reverse();
            _currentIndex = index;
            _iconAnimationControllers[index].forward();

            // Animate the indicator
            _indicatorAnimationController.reset();
            _indicatorAnimationController.forward();
          });
        },
        physics: const BouncingScrollPhysics(),
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
        if (_currentIndex != index) {
          setState(() {
            // Trigger animations
            _iconAnimationControllers[_currentIndex].reverse();
            _currentIndex = index;
            _iconAnimationControllers[index].forward();

            // Reset and start the indicator animation
            _indicatorAnimationController.reset();
            _indicatorAnimationController.forward();
          });

          // Animate to the selected page
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        height: 40,
        width: 64,
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _iconAnimationControllers[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: isSelected
                      ? 1.0 + (_iconAnimationControllers[index].value * 0.2)
                      : 1.0,
                  child: Icon(
                    _icons[index],
                    color: Color.lerp(
                      isDarkMode ? Colors.white : Colors.black54,
                      Colors.teal[400],
                      _iconAnimationControllers[index].value,
                    ),
                    size: 24,
                  ),
                );
              },
            ),
            if (isSelected)
              AnimatedBuilder(
                animation: _indicatorAnimation,
                builder: (context, child) {
                  return Positioned(
                    bottom: 6,
                    child: Transform.scale(
                      scale: _indicatorAnimation.value,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.teal[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
