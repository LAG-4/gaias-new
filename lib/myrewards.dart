import 'package:flutter/material.dart';
import 'package:gaia/marketplace.dart';
import 'package:gaia/requests.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';
import 'dart:math' as math;

class RewardCategory {
  final IconData icon;
  final Color color;
  final int points;

  RewardCategory({
    required this.icon,
    required this.color,
    required this.points,
  });
}

class MyRewards extends StatefulWidget {
  const MyRewards({Key? key}) : super(key: key);

  @override
  State<MyRewards> createState() => _MyRewardsState();
}

class _MyRewardsState extends State<MyRewards>
    with SingleTickerProviderStateMixin {
  final int totalPoints = 119;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<RewardCategory> _categories = [
    RewardCategory(
      icon: Icons.eco,
      color: Colors.green,
      points: 45,
    ),
    RewardCategory(
      icon: Icons.school,
      color: Colors.blue,
      points: 32,
    ),
    RewardCategory(
      icon: Icons.favorite,
      color: Colors.red,
      points: 25,
    ),
    RewardCategory(
      icon: Icons.people,
      color: Colors.orange,
      points: 17,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    )..addListener(() {
        setState(() {});
      });
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
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildRewardHeader(theme),
            ),
            title: Text(
              'My Rewards',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  Text(
                    'Impact Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Categories Graph
                  Container(
                    height: 220,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Points Distribution',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: _buildCategoriesGraph(theme),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Action Buttons
                  Text(
                    'Points Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Earn Points Card
                  _buildActionCard(
                    title: 'Earn Points',
                    subtitle: 'Volunteer, donate, or participate in events',
                    icon: Icons.add_circle_outline,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RequestPage()),
                      );
                    },
                    theme: theme,
                  ),

                  SizedBox(height: 16),

                  // Redeem Points Card
                  _buildActionCard(
                    title: 'Redeem Points',
                    subtitle: 'Exchange for rewards in the marketplace',
                    icon: Icons.redeem,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Marketplace()),
                      );
                    },
                    theme: theme,
                  ),

                  SizedBox(height: 24),

                  // History Section
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // History List
                  _buildHistoryItem(
                    title: 'Earned 18 points',
                    subtitle: 'Donation to Akshaya Patra',
                    date: 'Oct 28, 2023',
                    points: '+18',
                    isPositive: true,
                    theme: theme,
                  ),

                  _buildHistoryItem(
                    title: 'Redeemed 20 points',
                    subtitle: 'Carbon Offset Certificate',
                    date: 'Sep 15, 2023',
                    points: '-20',
                    isPositive: false,
                    theme: theme,
                  ),

                  _buildHistoryItem(
                    title: 'Earned 9 points',
                    subtitle: 'Volunteering at Children First',
                    date: 'Aug 10, 2023',
                    points: '+9',
                    isPositive: true,
                    theme: theme,
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardHeader(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Circular decorations
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Points display with animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: totalPoints.toDouble()),
                  duration: Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Text(
                      '${value.toInt()}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                Text(
                  'Total Reward Points',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),

                SizedBox(height: 8),

                // Animated progress bar
                Container(
                  height: 6,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 6,
                      width: 200 * _animation.value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 4),

                // Next tier text
                Text(
                  '31 points until next tier',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGraph(ThemeData theme) {
    // Calculate total points
    final totalCategoryPoints =
        _categories.fold<int>(0, (sum, category) => sum + category.points);

    return Row(
      children: [
        // Y-axis labels
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('50',
                style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.6))),
            Text('40',
                style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.6))),
            Text('30',
                style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.6))),
            Text('20',
                style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.6))),
            Text('10',
                style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.6))),
            Text('0',
                style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.6))),
          ],
        ),
        SizedBox(width: 8),

        // Graph
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  width: 1,
                ),
                bottom: BorderSide(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _categories.map((category) {
                // Calculate bar height based on points (max height for 50 points)
                double barHeight = (category.points / 50) * 125;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Bar value
                    Text(
                      '${category.points}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: category.color,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Animated bar
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: barHeight),
                      duration: Duration(seconds: 1, milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Container(
                          width: 30,
                          height: value,
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.7),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 4),

                    // Category icon
                    Icon(category.icon, size: 14, color: category.color),

                    // Category name
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: iconColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String subtitle,
    required String date,
    required String points,
    required bool isPositive,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPositive
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPositive ? Icons.add : Icons.remove,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              points,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
