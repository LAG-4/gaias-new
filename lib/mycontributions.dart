import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';
import 'package:gaia/myrewards.dart';

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
}

class MyContributions extends StatefulWidget {
  final Map<String, dynamic>? newContribution;

  const MyContributions({super.key, this.newContribution});

  @override
  State<MyContributions> createState() => _MyContributionsState();
}

class _MyContributionsState extends State<MyContributions> {
  String _currentFilter = "All";
  late List<Contribution> _contributions;
  final List<String> _filters = ["All", "Volunteer", "Donation"];

  // Initialize sample contribution data
  void _initializeContributions() {
    _contributions = [
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

    // Add new contribution if provided
    if (widget.newContribution != null) {
      // Add the new contribution at the top of the list
      _contributions.insert(0, Contribution.fromMap(widget.newContribution!));
    }
  }

  List<Contribution> get filteredContributions {
    if (_currentFilter == "All") {
      return _contributions;
    } else {
      return _contributions.where((c) => c.category == _currentFilter).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeContributions();

    // Set initial filter based on new contribution if provided
    if (widget.newContribution != null) {
      _currentFilter = widget.newContribution!['category'] ?? "All";
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
            child: filteredContributions.isEmpty
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
        label: Text(
          "${_calculateTotalPoints()} pts",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
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
