import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';
import 'package:gaia/myrewards.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

// User profile model to parse API response
class UserProfile {
  final String? firstName;
  final String? lastName;
  final String email;
  final int totalPoints;
  final List<DonationItem> donations;
  final bool isAdmin;

  UserProfile({
    this.firstName,
    this.lastName,
    required this.email,
    required this.totalPoints,
    required this.donations,
    required this.isAdmin,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    List<DonationItem> donationsList = [];
    if (json['donations'] != null) {
      donationsList = List<DonationItem>.from(
        json['donations'].map((donation) => DonationItem.fromJson(donation)),
      );
    }

    return UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'] ?? 'Unknown',
      totalPoints: json['totalPoints'] ?? 0,
      donations: donationsList,
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}

// Donation item model for user profile
class DonationItem {
  final int id;
  final int userId;
  final double donationAmount;
  final String donationDate;
  final int pointsEarned;
  final String? ngoName;

  DonationItem({
    required this.id,
    required this.userId,
    required this.donationAmount,
    required this.donationDate,
    required this.pointsEarned,
    this.ngoName,
  });

  factory DonationItem.fromJson(Map<String, dynamic> json) {
    return DonationItem(
      id: json['id'],
      userId: json['userId'],
      donationAmount: json['donationAmount'] ?? 0.0,
      donationDate: json['donationDate'] ?? '',
      pointsEarned: json['pointsEarned'] ?? 0,
      ngoName: json['ngoName'],
    );
  }
}

class Contribution {
  final String ngoName;
  final String location;
  final String description;
  final String date;
  final int points;
  final String category; // "Donation" or "Volunteer"
  final IconData icon; // Icon to represent the contribution

  Contribution({
    required this.ngoName,
    required this.location,
    required this.description,
    required this.date,
    required this.points,
    required this.category,
    required this.icon,
  });

  // Create from a map
  factory Contribution.fromMap(Map<String, dynamic> map) {
    // Convert string icon identifier to IconData
    IconData iconData;
    var iconValue = map['icon'];

    if (iconValue is String) {
      // Handle string-based icon identifiers
      switch (iconValue) {
        case 'money':
          iconData = Icons.attach_money;
          break;
        case 'food':
          iconData = Icons.restaurant;
          break;
        case 'clothes':
          iconData = Icons.checkroom;
          break;
        case 'items':
          iconData = Icons.shopping_bag;
          break;
        case 'volunteer':
          iconData = Icons.people;
          break;
        default:
          iconData = Icons.volunteer_activism;
      }
    } else if (iconValue is IconData) {
      // Already an IconData
      iconData = iconValue;
    } else {
      // Default fallback
      iconData = Icons.volunteer_activism;
    }

    return Contribution(
      ngoName: map['ngoName'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      points: map['points'] ?? 0,
      category: map['category'] ?? 'Donation',
      icon: iconData,
    );
  }

  // Create from API response
  factory Contribution.fromApi(Map<String, dynamic> apiData) {
    // Format the date from API (assuming ISO format)
    String formattedDate = '';
    if (apiData['donationDate'] != null) {
      try {
        DateTime dateTime = DateTime.parse(apiData['donationDate']);
        formattedDate = '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
      } catch (e) {
        formattedDate = 'Unknown date';
        print('Error parsing date: $e');
      }
    }

    // Determine NGO name
    String ngoName = apiData['ngoName'] ?? 'Unknown Organization';
    
    return Contribution(
      ngoName: ngoName,
      location: 'India', // Default location since API doesn't provide it
      description: 'Donation of ₹${apiData['donationAmount']}',
      date: formattedDate,
      points: apiData['pointsEarned'] ?? 0,
      category: 'Donation', // Assuming all API entries are donations
      icon: Icons.attach_money,
    );
  }

  // Helper method to convert month number to name
  static String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }
}

class MyContributions extends StatefulWidget {
  final Map<String, dynamic>? newContribution;

  const MyContributions({super.key, this.newContribution});

  @override
  State<MyContributions> createState() => _MyContributionsState();
}

class _MyContributionsState extends State<MyContributions> {
  List<Contribution> _contributions = [];
  final List<String> _filters = ["All", "Donation", "Volunteer"];
  String _currentFilter = "All";
  bool _isLoading = true;
  String? _errorMessage;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _fetchContributions();
    _fetchUserProfile();
  }

  // Fetch user profile from API
  Future<void> _fetchUserProfile() async {
    try {
      // Get the auth token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        print('Authentication token not found for profile fetch');
        return;
      }

      print('Fetching user profile with token: ${token.substring(0, min(20, token.length))}...');

      // Make API request with the token
      final response = await http.get(
        Uri.parse('https://ngo-app-3mvh.onrender.com/api/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Profile API Response Status: ${response.statusCode}');
      print('Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Success - parse the data
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Parse user profile
        setState(() {
          _userProfile = UserProfile.fromJson(data);
        });
        
        print('User profile fetched successfully. Total points: ${_userProfile?.totalPoints}');
      } else {
        print('Failed to fetch user profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during profile fetch: $e');
    }
  }

  // Fetch contributions from API
  Future<void> _fetchContributions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the auth token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Authentication token not found. Please login again.';
          _isLoading = false;
          // Fall back to sample data
          _contributions = _getSampleContributions();
        });
        return;
      }

      print('Using token: ${token.substring(0, min(20, token.length))}...');

      // Make API request with the token
      final response = await http.get(
        Uri.parse('https://ngo-app-3mvh.onrender.com/api/user/profile/donations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Success - parse the data
        final List<dynamic> data = json.decode(response.body);
        
        print('Parsed data: $data');
        
        // Convert API data to Contribution objects
        List<Contribution> apiContributions = data
            .map((item) => Contribution.fromApi(item))
            .toList();
        
        // Initialize with sample data if needed (for testing)
        List<Contribution> sampleContributions = _getSampleContributions();
        
        setState(() {
          // For now, let's use both API data and sample data
          _contributions = [...apiContributions, ...sampleContributions];
          
          // Add new contribution if provided
          if (widget.newContribution != null) {
            _contributions.insert(0, Contribution.fromMap(widget.newContribution!));
          }
          
          _isLoading = false;
        });
      } else if (response.statusCode == 400) {
        // Handle "no donations yet" response
        try {
          final errorData = json.decode(response.body);
          if (errorData['errorMsg'] != null && 
              errorData['errorMsg'].toString().contains("not done any donations yet")) {
            print('User has no donations yet');
            
            setState(() {
              // Just use sample data and any new contribution
              _contributions = _getSampleContributions();
              
              // Add new contribution if provided
              if (widget.newContribution != null) {
                _contributions.insert(0, Contribution.fromMap(widget.newContribution!));
              }
              
              _isLoading = false;
            });
            return;
          }
        } catch (e) {
          // If parsing fails, handle as generic error
          print('Error parsing 400 response: $e');
        }
        
        // Handle as generic error if not a "no donations" message
        setState(() {
          _errorMessage = 'Failed to load contributions. Please try again later.';
          _isLoading = false;
          _contributions = _getSampleContributions();
          
          // Add new contribution if provided
          if (widget.newContribution != null) {
            _contributions.insert(0, Contribution.fromMap(widget.newContribution!));
          }
        });
      } else if (response.statusCode == 401) {
        // Handle unauthorized error specifically
        print('Unauthorized access. Token may be invalid or expired.');
        
        // Try to parse error message from response
        String errorMsg = 'Authentication failed. Please login again.';
        try {
          final errorData = json.decode(response.body);
          if (errorData['error'] != null) {
            errorMsg = errorData['error'];
          }
        } catch (e) {
          // If parsing fails, use default message
        }
        
        setState(() {
          _errorMessage = errorMsg;
          _isLoading = false;
          
          // Fall back to sample data
          _contributions = _getSampleContributions();
          
          // Add new contribution if provided
          if (widget.newContribution != null) {
            _contributions.insert(0, Contribution.fromMap(widget.newContribution!));
          }
        });
      } else {
        // Handle other errors
        setState(() {
          _errorMessage = 'Failed to load contributions. Status code: ${response.statusCode}';
          _isLoading = false;
          
          // Fall back to sample data
          _contributions = _getSampleContributions();
          
          // Add new contribution if provided
          if (widget.newContribution != null) {
            _contributions.insert(0, Contribution.fromMap(widget.newContribution!));
          }
        });
        print('API Error: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching contributions: $e';
        _isLoading = false;
        
        // Fall back to sample data
        _contributions = _getSampleContributions();
        
        // Add new contribution if provided
        if (widget.newContribution != null) {
          _contributions.insert(0, Contribution.fromMap(widget.newContribution!));
        }
      });
      print('Exception: $e');
    }
  }

  // Get sample contribution data for fallback
  List<Contribution> _getSampleContributions() {
    return [
      Contribution(
        ngoName: "Akshaya Patra",
        location: "Delhi, India",
        description: "Donated to mid-day meal program for school children",
        date: "28 Oct 2023",
        points: 18,
        category: "Donation",
        icon: Icons.emoji_food_beverage,
      ),
      Contribution(
        ngoName: "Children First",
        location: "Jaipur, India",
        description: "Participated in awareness campaign",
        date: "20 Nov 2024",
        points: 9,
        category: "Volunteer",
        icon: Icons.favorite,
      ),
      Contribution(
        ngoName: "CRY Foundation",
        location: "Mumbai, India",
        description: "Donated to support underprivileged children",
        date: "15 Aug 2024",
        points: 115,
        category: "Donation",
        icon: Icons.attach_money,
      ),
    ];
  }

  List<Contribution> get filteredContributions {
    if (_currentFilter == "All") {
      return _contributions;
    } else {
      return _contributions.where((c) => c.category == _currentFilter).toList();
    }
  }

  // Get month headers and their positions in the list
  Map<String, List<Contribution>> _groupByMonth() {
    Map<String, List<Contribution>> grouped = {};

    for (var contribution in filteredContributions) {
      String month = _extractMonth(contribution.date);
      if (!grouped.containsKey(month)) {
        grouped[month] = [];
      }
      grouped[month]!.add(contribution);
    }

    return grouped;
  }

  // Extract month from date string
  String _extractMonth(String date) {
    // Assuming format is "DD MMM YYYY" like "28 Oct 2023"
    List<String> parts = date.split(' ');
    if (parts.length >= 3) {
      String month = parts[1];
      String year = parts[2];
      return "$month $year";
    }
    return "";
  }

  // Calculate total points
  int _calculateTotalPoints() {
    // If user profile is available, use the total points from API
    if (_userProfile != null) {
      return _userProfile!.totalPoints;
    }
    
    // Fallback to calculating from local contributions
    return filteredContributions.isEmpty
        ? 0
        : filteredContributions.map((c) => c.points).reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Contributions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            height: 56,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _currentFilter == filter;

                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _currentFilter = filter;
                    });
                  },
                  backgroundColor: theme.colorScheme.surface,
                  selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  checkmarkColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                );
              },
            ),
          ),

          // Contributions list
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Text(_errorMessage!),
                      )
                    : filteredContributions.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.volunteer_activism,
                                  size: 64,
                                  color: theme.colorScheme.primary.withOpacity(0.5),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "No $_currentFilter contributions yet",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemCount: _groupByMonth().length,
                            itemBuilder: (context, index) {
                              final entries = _groupByMonth().entries.toList();
                              final month = entries[index].key;
                              final monthContributions = entries[index].value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Month header
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Text(
                                      month,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),

                                  // Month contributions
                                  ...monthContributions.map((contribution) =>
                                      _buildContributionCard(contribution, theme)),
                                ],
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to MyRewards page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyRewards()),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        icon: Icon(
          Icons.star_rounded,
          color: theme.colorScheme.onPrimary,
        ),
        label: Row(
          children: [
            Text(
              "${_calculateTotalPoints()} pts",
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_userProfile != null && _userProfile!.donations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "(${_userProfile!.donations.length} donations)",
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributionCard(Contribution contribution, ThemeData theme) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Show contribution details
          _showContributionDetails(contribution);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with NGO and Category
              Row(
                children: [
                  // Icon in a circular container
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: contribution.category == "Volunteer"
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      contribution.icon,
                      size: 20,
                      color: contribution.category == "Volunteer"
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  SizedBox(width: 12),
                  // NGO name and location
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contribution.ngoName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                contribution.location,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Category badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: contribution.category == "Volunteer"
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      contribution.category,
                      style: TextStyle(
                        color: contribution.category == "Volunteer"
                            ? Colors.green
                            : Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Description
              Text(
                contribution.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12),

              // Date and points
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    contribution.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${contribution.points} points",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContributionDetails(Contribution contribution) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with NGO name and badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            contribution.ngoName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: contribution.category == "Volunteer"
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            contribution.category,
                            style: TextStyle(
                              color: contribution.category == "Volunteer"
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Icon and points
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: contribution.category == "Volunteer"
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            contribution.icon,
                            size: 32,
                            color: contribution.category == "Volunteer"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${contribution.points}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Impact Points",
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Info items
                    _infoItem(context, Icons.description_outlined,
                        "Description", contribution.description),

                    _infoItem(context, Icons.location_on_outlined, "Location",
                        contribution.location),

                    _infoItem(context, Icons.calendar_today_outlined, "Date",
                        contribution.date),

                    SizedBox(height: 32),

                    // Certificate button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Generate certificate feature
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Certificate will be generated soon'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: Icon(Icons.verified),
                      label: Text("Generate Certificate"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Share button
                    OutlinedButton.icon(
                      onPressed: () {
                        // Share contribution
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sharing functionality coming soon'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: Icon(Icons.share),
                      label: Text("Share Impact"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
      BuildContext context, IconData icon, String title, String content) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
