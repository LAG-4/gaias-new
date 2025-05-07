import 'package:flutter/material.dart';
import 'package:gaia/base_page.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';
import 'package:gaia/mycontributions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class RequestModel {
  final String id;
  final String title;
  final String description;
  final String ngoName;
  final String category;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final bool isBase64Image;
  final int pointsReward;
  final DateTime datePosted;
  
  RequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ngoName,
    required this.category,
    this.imageUrl,
    this.imageBytes,
    required this.isBase64Image,
    required this.pointsReward,
    required this.datePosted,
  });

  // Factory constructor to create a RequestModel from API data
  factory RequestModel.fromApi(Map<String, dynamic> json) {
    // Extract tags and convert to a list
    List<String> tagsList = [];
    if (json['tags'] != null) {
      tagsList = json['tags'].toString().split(',');
    }
    
    // Determine category based on tags or use the category field
    String category = json['category'] ?? 'General';
    
    // Handle the image - could be base64 or URL
    String? imageUrl;
    Uint8List? imageBytes;
    bool isBase64Image = false;
    
    if (json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty) {
      String imageData = json['imageUrl'].toString();
      
      // Check if it's a base64 image
      if (imageData.startsWith('/9j') || imageData.startsWith('data:image')) {
        try {
          // If it starts with 'data:image', extract the base64 part
          if (imageData.startsWith('data:image')) {
            imageData = imageData.split(',')[1];
          }
          
          // Decode base64 to bytes
          imageBytes = base64Decode(imageData);
          isBase64Image = true;
        } catch (e) {
          print('Error decoding base64 image: $e');
          imageUrl = 'assets/a.jpg'; // Fallback to placeholder
        }
      } else {
        // It's a regular URL
        imageUrl = imageData;
      }
    } else {
      // No image, use placeholder
      imageUrl = 'assets/a.jpg';
    }
    
    return RequestModel(
      id: json['id'].toString(),
      title: json['title'] ?? 'No Title',
      description: json['content'] ?? 'No Description',
      ngoName: json['username'] ?? 'Unknown',
      category: category,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      isBase64Image: isBase64Image,
      pointsReward: 25, // Default points
      datePosted: DateTime.now().subtract(const Duration(days: 2)), // Default date
    );
  }
}

class _RequestPageState extends State<RequestPage> {
  String _selectedCategory = 'All';
  bool _isLoading = true;
  List<RequestModel> _requests = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://ngo-app-requests.onrender.com/api/requests/fetch'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        setState(() {
          _requests = data.map((item) => RequestModel.fromApi(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load requests. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching requests: $e';
        _isLoading = false;
      });
    }
  }

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
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _fetchRequests,
                    tooltip: 'Refresh',
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
                    _buildFilterChip('General', theme),
                    _buildFilterChip('Health', theme),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Request cards
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchRequests,
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        )
                      : filteredRequests.isEmpty
                          ? Center(
                              child: Text(
                                'No requests found',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6)),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _fetchRequests,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: filteredRequests.length,
                                itemBuilder: (context, index) {
                                  final request = filteredRequests[index];
                                  return _buildRequestCard(request, theme);
                                },
                              ),
                            ),
            ),
          ],
        ),
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

    switch (request.category.toLowerCase()) {
      case 'food':
        categoryIcon = Icons.restaurant;
        categoryColor = Colors.orange;
        break;
      case 'volunteer':
        categoryIcon = Icons.people;
        categoryColor = Colors.blue;
        break;
      case 'clothes':
        categoryIcon = Icons.checkroom;
        categoryColor = Colors.purple;
        break;
      case 'money':
        categoryIcon = Icons.attach_money;
        categoryColor = Colors.green;
        break;
      case 'health':
        categoryIcon = Icons.health_and_safety;
        categoryColor = Colors.red;
        break;
      default:
        categoryIcon = Icons.help_outline;
        categoryColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: _buildRequestImage(request, 180),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(categoryIcon, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          request.category,
                          style: const TextStyle(
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '+${request.pointsReward} pts',
                          style: const TextStyle(
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
                    style: const TextStyle(
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
                      const SizedBox(width: 6),
                      Text(
                        request.ngoName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${request.datePosted.difference(DateTime.now()).inDays.abs()} days ago',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    request.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the appropriate image widget based on the request type
  Widget _buildRequestImage(RequestModel request, double height) {
    if (request.isBase64Image && request.imageBytes != null) {
      // Display base64 image
      return Image.memory(
        request.imageBytes!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImagePlaceholder(height);
        },
      );
    } else if (request.imageUrl != null) {
      if (request.imageUrl!.startsWith('assets/')) {
        // Display asset image
        return Image.asset(
          request.imageUrl!,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        // Display network image
        return Image.network(
          request.imageUrl!,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorImagePlaceholder(height);
          },
        );
      }
    } else {
      // Fallback placeholder
      return _buildErrorImagePlaceholder(height);
    }
  }

  // Helper method for error placeholder
  Widget _buildErrorImagePlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.image_not_supported,
        size: 50,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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

    switch (widget.request.category.toLowerCase()) {
      case 'food':
        categoryIcon = Icons.restaurant;
        categoryColor = Colors.orange;
        break;
      case 'volunteer':
        categoryIcon = Icons.people;
        categoryColor = Colors.blue;
        break;
      case 'clothes':
        categoryIcon = Icons.checkroom;
        categoryColor = Colors.purple;
        break;
      case 'money':
        categoryIcon = Icons.attach_money;
        categoryColor = Colors.green;
        break;
      case 'health':
        categoryIcon = Icons.health_and_safety;
        categoryColor = Colors.red;
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildDetailImage(widget.request),
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
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(categoryIcon, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                widget.request.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.request.title,
                          style: const TextStyle(
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
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.request.ngoName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
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
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement profile view
                        },
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: const Text('Profile'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Reward points
                  Container(
                    padding: const EdgeInsets.all(16),
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
                        const SizedBox(width: 12),
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

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About this request',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.request.description +
                        '\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla facilisi. Maecenas non urna nec nunc tincidunt luctus. Donec vel neque vitae elit tempor blandit. Suspendisse potenti. Proin aliquam, nisi in commodo iaculis, ex lacus tempor tortor, at volutpat nulla magna vel nunc.\n\nMaecenas dictum felis vel justo tincidunt, a rhoncus magna vulputate. Fusce lobortis nisi quis enim varius, ac laoreet lorem volutpat.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Details
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
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

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              _showContributionDialog(context, widget.request);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
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

  // Helper method to build the image for detail page
  Widget _buildDetailImage(RequestModel request) {
    if (request.isBase64Image && request.imageBytes != null) {
      // Display base64 image
      return Image.memory(
        request.imageBytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImagePlaceholder();
        },
      );
    } else if (request.imageUrl != null) {
      if (request.imageUrl!.startsWith('assets/')) {
        // Display asset image
        return Image.asset(
          request.imageUrl!,
          fit: BoxFit.cover,
        );
      } else {
        // Display network image
        return Image.network(
          request.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorImagePlaceholder();
          },
        );
      }
    } else {
      // Fallback placeholder
      return _buildErrorImagePlaceholder();
    }
  }

  // Helper method for error placeholder
  Widget _buildErrorImagePlaceholder() {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.image_not_supported,
        size: 50,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
            padding: const EdgeInsets.all(10),
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
          const SizedBox(width: 16),
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
                style: const TextStyle(
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
              const SizedBox(height: 24),
              Text(
                'Contribute to ${request.title}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'How would you like to contribute?',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),

              // Contribution options
              _buildContributionOption(
                icon: Icons.attach_money,
                title: 'Donate Money',
                subtitle: 'Support with financial contribution',
                theme: theme,
                onTap: () async {
                  // Show loading indicator
                  _showLoadingDialog(context);
                  
                  // Make API call to donate
                  bool success = await _makeDonationApiCall(
                    context: context,
                    donationType: 'money',
                    amount: 50000, // Default amount (₹500)
                  );
                  
                  // Close loading dialog
                  Navigator.pop(context);
                  
                  // Close contribution dialog
                  Navigator.pop(context);
                  
                  if (success) {
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
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to make donation. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildContributionOption(
                icon: Icons.restaurant,
                title: 'Donate Items',
                subtitle: 'Contribute food, clothes, or other items',
                theme: theme,
                onTap: () async {
                  // Determine appropriate icon and description
                  String iconType;
                  String description;

                  switch (request.category.toLowerCase()) {
                    case 'food':
                      iconType = 'food';
                      description = 'Donated food items for ${request.title}';
                      break;
                    case 'clothes':
                      iconType = 'clothes';
                      description = 'Donated clothes for ${request.title}';
                      break;
                    default:
                      iconType = 'items';
                      description = 'Donated items for ${request.title}';
                  }
                  
                  // Show loading indicator
                  _showLoadingDialog(context);
                  
                  // Make API call to donate
                  bool success = await _makeDonationApiCall(
                    context: context,
                    donationType: 'items',
                    amount: 10000, // Default amount (₹100)
                  );
                  
                  // Close loading dialog
                  Navigator.pop(context);
                  
                  // Close contribution dialog
                  Navigator.pop(context);
                  
                  if (success) {
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
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to make donation. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildContributionOption(
                icon: Icons.people,
                title: 'Volunteer Time',
                subtitle: 'Offer your skills and time',
                theme: theme,
                onTap: () async {
                  // Show loading indicator
                  _showLoadingDialog(context);
                  
                  // Make API call to donate
                  bool success = await _makeDonationApiCall(
                    context: context,
                    donationType: 'volunteer',
                    amount: 5000, // Default amount (₹50)
                  );
                  
                  // Close loading dialog
                  Navigator.pop(context);
                  
                  // Close contribution dialog
                  Navigator.pop(context);
                  
                  if (success) {
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
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to register volunteer time. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to make the donation API call
  Future<bool> _makeDonationApiCall({
    required BuildContext context,
    required String donationType,
    required int amount,
  }) async {
    try {
      // Get the auth token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        print('Authentication token not found');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication token not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }

      print('Making donation API call with token: ${token.substring(0, 20)}...');

      // Make API request with the token
      final response = await http.post(
        Uri.parse('https://ngo-app-3mvh.onrender.com/api/user/donate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'donationAmount': amount,
          'donationType': donationType,
        }),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you for your ${donationType} donation!'),
            backgroundColor: Colors.green,
          ),
        );
        return true;
      } else {
        // Handle error
        String errorMessage = 'Failed to make donation';
        try {
          final errorData = json.decode(response.body);
          if (errorData['errorMsg'] != null) {
            errorMessage = errorData['errorMsg'];
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        } catch (e) {
          // If parsing fails, use default message
        }
        
        print('Donation API error: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      print('Exception during donation API call: $e');
      return false;
    }
  }

  // Show a loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                const Text("Processing donation..."),
              ],
            ),
          ),
        );
      },
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
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
