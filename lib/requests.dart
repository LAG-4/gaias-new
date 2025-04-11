import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaia/base_page.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';
import 'package:gaia/mycontributions.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class RequestModel {
  final String id;
  final String title;
  final String description;
  final String ngoName;
  final String category;
  final String imageUrl;
  final int pointsReward;
  final DateTime datePosted;

  RequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ngoName,
    required this.category,
    required this.imageUrl,
    required this.pointsReward,
    required this.datePosted,
  });
}

class _RequestPageState extends State<RequestPage> {
  // final _firestore = FirebaseFirestore.instance;
  // final _auth = FirebaseAuth.instance;

  String _selectedCategory = 'All';

  // Mock data - to be replaced with Firebase data
  final List<RequestModel> _requests = [
    RequestModel(
      id: '1',
      title: 'Food Donation Drive',
      description:
          'Help us provide meals to 200 underprivileged children. We need non-perishable food items.',
      ngoName: 'Feed The Future',
      category: 'Food',
      imageUrl: 'assets/a.jpg',
      pointsReward: 25,
      datePosted: DateTime.now().subtract(Duration(days: 2)),
    ),
    RequestModel(
      id: '2',
      title: 'Teaching Volunteers Needed',
      description:
          'Looking for volunteers to teach basic computer skills to students from low-income communities.',
      ngoName: 'Digital Bridge',
      category: 'Volunteer',
      imageUrl: 'assets/b.jpg',
      pointsReward: 40,
      datePosted: DateTime.now().subtract(Duration(days: 5)),
    ),
    RequestModel(
      id: '3',
      title: 'Winter Clothing Collection',
      description:
          'Collecting warm clothes for homeless people as winter approaches. Jackets, sweaters and blankets needed.',
      ngoName: 'Warm Hearts',
      category: 'Clothes',
      imageUrl: 'assets/c.jpg',
      pointsReward: 20,
      datePosted: DateTime.now().subtract(Duration(days: 3)),
    ),
    RequestModel(
      id: '4',
      title: 'Clean Water Initiative',
      description:
          'Help us fund clean water wells in rural villages. Each well costs approximately \$2000 and serves 500 people.',
      ngoName: 'Water For All',
      category: 'Money',
      imageUrl: 'assets/a.jpg',
      pointsReward: 35,
      datePosted: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Filtered requests based on selected category
    final filteredRequests = _selectedCategory == 'All'
        ? _requests
        : _requests.where((req) => req.category == _selectedCategory).toList();

    return BasePage(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header without back button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Help Requests',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Category filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', theme),
                    _buildFilterChip('Food', theme),
                    _buildFilterChip('Volunteer', theme),
                    _buildFilterChip('Clothes', theme),
                    _buildFilterChip('Money', theme),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8),

            // Request cards
            Expanded(
              child: filteredRequests.isEmpty
                  ? Center(
                      child: Text(
                        'No requests found',
                        style: TextStyle(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return _buildRequestCard(request, theme);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add functionality for organizations to create new requests
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        tooltip: 'Create Request',
      ),
    );
  }

  Widget _buildFilterChip(String category, ThemeData theme) {
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(category),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: theme.cardColor,
        selectedColor: theme.colorScheme.primary.withOpacity(0.2),
        checkmarkColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildRequestCard(RequestModel request, ThemeData theme) {
    // Choose icon based on category
    IconData categoryIcon;
    Color categoryColor;

    switch (request.category) {
      case 'Food':
        categoryIcon = Icons.restaurant;
        categoryColor = Colors.orange;
        break;
      case 'Volunteer':
        categoryIcon = Icons.people;
        categoryColor = Colors.blue;
        break;
      case 'Clothes':
        categoryIcon = Icons.checkroom;
        categoryColor = Colors.purple;
        break;
      case 'Money':
        categoryIcon = Icons.attach_money;
        categoryColor = Colors.green;
        break;
      default:
        categoryIcon = Icons.help_outline;
        categoryColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestDetailPage(request: request),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay and category icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    request.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(categoryIcon, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          request.category,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '+${request.pointsReward} pts',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Text(
                    request.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(width: 6),
                      Text(
                        request.ngoName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${request.datePosted.difference(DateTime.now()).inDays.abs()} days ago',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    request.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RequestDetailPage(request: request),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Contribute'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestDetailPage extends StatefulWidget {
  final RequestModel request;

  const RequestDetailPage({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Choose icon based on category
    IconData categoryIcon;
    Color categoryColor;

    switch (widget.request.category) {
      case 'Food':
        categoryIcon = Icons.restaurant;
        categoryColor = Colors.orange;
        break;
      case 'Volunteer':
        categoryIcon = Icons.people;
        categoryColor = Colors.blue;
        break;
      case 'Clothes':
        categoryIcon = Icons.checkroom;
        categoryColor = Colors.purple;
        break;
      case 'Money':
        categoryIcon = Icons.attach_money;
        categoryColor = Colors.green;
        break;
      default:
        categoryIcon = Icons.help_outline;
        categoryColor = Colors.grey;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.request.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(categoryIcon, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text(
                                widget.request.category,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.request.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NGO info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.2),
                        child: Icon(
                          Icons.account_balance,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.request.ngoName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Verified Organization',
                            style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement profile view
                        },
                        icon: Icon(Icons.info_outline, size: 16),
                        label: Text('Profile'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Reward points
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Earn ${widget.request.pointsReward} points by contributing',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Description
                  Text(
                    'About this request',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.request.description +
                        '\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla facilisi. Maecenas non urna nec nunc tincidunt luctus. Donec vel neque vitae elit tempor blandit. Suspendisse potenti. Proin aliquam, nisi in commodo iaculis, ex lacus tempor tortor, at volutpat nulla magna vel nunc.\n\nMaecenas dictum felis vel justo tincidunt, a rhoncus magna vulputate. Fusce lobortis nisi quis enim varius, ac laoreet lorem volutpat.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Details
                  Text(
                    'Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildDetailItem(
                    icon: Icons.access_time,
                    title: 'Posted',
                    subtitle:
                        '${widget.request.datePosted.difference(DateTime.now()).inDays.abs()} days ago',
                    theme: theme,
                  ),
                  _buildDetailItem(
                    icon: Icons.location_on,
                    title: 'Location',
                    subtitle: 'Mumbai, Maharashtra',
                    theme: theme,
                  ),
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    title: 'Deadline',
                    subtitle: 'December 25, 2023',
                    theme: theme,
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement contribution flow
              _showContributionDialog(context, widget.request);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Contribute Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showContributionDialog(BuildContext context, RequestModel request) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Contribute to ${request.title}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'How would you like to contribute?',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 24),

              // Contribution options
              _buildContributionOption(
                icon: Icons.attach_money,
                title: 'Donate Money',
                subtitle: 'Support with financial contribution',
                theme: theme,
                onTap: () {
                  Navigator.pop(context);

                  // Create a contribution and go to MyContributions
                  Map<String, dynamic> contribution = {
                    'ngoName': request.ngoName,
                    'location': 'Mumbai, Maharashtra',
                    'description': 'Donated money for ${request.title}',
                    'date':
                        '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                    'points': request.pointsReward,
                    'category': 'Donation',
                    'icon': 'money',
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyContributions(newContribution: contribution),
                    ),
                  );
                },
              ),
              SizedBox(height: 12),
              _buildContributionOption(
                icon: Icons.restaurant,
                title: 'Donate Items',
                subtitle: 'Contribute food, clothes, or other items',
                theme: theme,
                onTap: () {
                  Navigator.pop(context);

                  // Determine appropriate icon and description
                  String iconType;
                  String description;

                  switch (request.category) {
                    case 'Food':
                      iconType = 'food';
                      description = 'Donated food items for ${request.title}';
                      break;
                    case 'Clothes':
                      iconType = 'clothes';
                      description = 'Donated clothes for ${request.title}';
                      break;
                    default:
                      iconType = 'items';
                      description = 'Donated items for ${request.title}';
                  }

                  // Create a contribution and go to MyContributions
                  Map<String, dynamic> contribution = {
                    'ngoName': request.ngoName,
                    'location': 'Mumbai, Maharashtra',
                    'description': description,
                    'date':
                        '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                    'points': request.pointsReward,
                    'category': 'Donation',
                    'icon': iconType,
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyContributions(newContribution: contribution),
                    ),
                  );
                },
              ),
              SizedBox(height: 12),
              _buildContributionOption(
                icon: Icons.people,
                title: 'Volunteer Time',
                subtitle: 'Offer your skills and time',
                theme: theme,
                onTap: () {
                  Navigator.pop(context);

                  // Create a contribution and go to MyContributions
                  Map<String, dynamic> contribution = {
                    'ngoName': request.ngoName,
                    'location': 'Mumbai, Maharashtra',
                    'description': 'Volunteered time for ${request.title}',
                    'date':
                        '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                    'points': request.pointsReward,
                    'category': 'Volunteer',
                    'icon': 'volunteer',
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyContributions(newContribution: contribution),
                    ),
                  );
                },
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to convert month number to name
  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }

  Widget _buildContributionOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24,
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
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
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
    );
  }
}
