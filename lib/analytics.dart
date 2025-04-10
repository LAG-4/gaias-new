import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

// Simple data models for the modern NGO page
class FundingData {
  final String month;
  final double amount;

  FundingData(this.month, this.amount);
}

class ImpactData {
  final String category;
  final double percentage;
  final Color color;
  final IconData icon;

  ImpactData({
    required this.category,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

class AnalyticsPage extends StatefulWidget {
  final Map<String, dynamic>? ngoData;

  const AnalyticsPage({Key? key, this.ngoData}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  // NGO information
  late Map<String, dynamic> _ngoInfo;
  late TabController _tabController;
  final scrollController = ScrollController();

  // Funding data
  final List<FundingData> _fundingData = [
    FundingData('Jan', 1.2),
    FundingData('Feb', 1.8),
    FundingData('Mar', 2.3),
    FundingData('Apr', 2.0),
    FundingData('May', 3.2),
    FundingData('Jun', 3.8),
    FundingData('Jul', 3.5),
    FundingData('Aug', 4.1),
    FundingData('Sep', 4.8),
    FundingData('Oct', 5.2),
    FundingData('Nov', 6.0),
    FundingData('Dec', 7.5),
  ];

  // Impact data
  final List<ImpactData> _impactData = [
    ImpactData(
      category: 'Education',
      percentage: 35,
      color: Colors.teal,
      icon: Icons.school,
    ),
    ImpactData(
      category: 'Healthcare',
      percentage: 25,
      color: Colors.blue,
      icon: Icons.health_and_safety,
    ),
    ImpactData(
      category: 'Nutrition',
      percentage: 20,
      color: Colors.orange,
      icon: Icons.restaurant,
    ),
    ImpactData(
      category: 'Infrastructure',
      percentage: 20,
      color: Colors.purple,
      icon: Icons.business,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeNGOData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _initializeNGOData() {
    // Use provided data or fallback to modern default
    _ngoInfo = widget.ngoData ??
        {
          "image": "assets/1.png",
          "name": "Navajeevan Bala Bhavan",
          "location": "Vijayawada, Andhra Pradesh",
          "about":
              "Navajeevan is a pioneering NGO dedicated to improving the lives of vulnerable children through comprehensive care, education, and developmental opportunities.",
          "description":
              "For over 20 years, we have been working with street children, orphans, and those from underprivileged backgrounds. Our holistic approach addresses immediate needs while ensuring long-term sustainable development.",
          "mission":
              "To create a society where every child has access to opportunities for comprehensive development regardless of their socio-economic background.",
          "vision":
              "A world where every child enjoys their rights to survival, protection, development and participation.",
          "volunteers": 120,
          "rating": 4.8,
          "founded": "2000",
          "phone": "+91 866 2572275",
          "email": "info@navajeevan.org",
          "website": "https://www.navajeevan.org",
          "beneficiaries": 5000,
          "projects": 25,
          "fundraising_goal": "₹25 Million",
          "donations_received": "₹18.6 Million",
          "progress": 75, // percentage complete
          "achievements": [
            "Rehabilitated over 15,000 street children",
            "Built 12 schools in rural communities",
            "Trained 500+ youth in vocational skills",
            "Provided healthcare to 20,000+ underprivileged",
            "Established 8 vocational training centers"
          ],
          "goals": [
            "Increase education outreach by 30% in 2024",
            "Launch 3 new healthcare initiatives",
            "Expand nutrition program to 10 new villages",
            "Develop sustainable water solutions for 5 communities"
          ]
        };

    // Ensure all required fields have default values
    _ngoInfo["name"] = _ngoInfo["name"] ?? "Sample NGO";
    _ngoInfo["location"] = _ngoInfo["location"] ?? "Multiple Locations";
    _ngoInfo["about"] = _ngoInfo["about"] ??
        "This NGO works to improve lives in communities around the world.";
    _ngoInfo["description"] = _ngoInfo["description"] ??
        "Working tirelessly to create positive change in communities worldwide.";
    _ngoInfo["mission"] = _ngoInfo["mission"] ??
        "To create lasting positive change in communities through sustainable development.";
    _ngoInfo["vision"] = _ngoInfo["vision"] ??
        "A world where everyone has access to essential resources and opportunities.";
    _ngoInfo["volunteers"] = _ngoInfo["volunteers"] ?? 100;
    _ngoInfo["rating"] = _ngoInfo["rating"] ?? 4.5;
    _ngoInfo["founded"] = _ngoInfo["founded"] ?? "2010";
    _ngoInfo["phone"] = _ngoInfo["phone"] ?? "+91 123 456 7890";
    _ngoInfo["email"] = _ngoInfo["email"] ?? "contact@samplengo.org";
    _ngoInfo["website"] = _ngoInfo["website"] ?? "https://www.samplengo.org";
    _ngoInfo["beneficiaries"] = _ngoInfo["beneficiaries"] ?? 1000;
    _ngoInfo["projects"] = _ngoInfo["projects"] ?? 10;
    _ngoInfo["fundraising_goal"] =
        _ngoInfo["fundraising_goal"] ?? "₹10 Million";
    _ngoInfo["donations_received"] =
        _ngoInfo["donations_received"] ?? "₹7.5 Million";
    _ngoInfo["progress"] = _ngoInfo["progress"] ?? 75;

    if (_ngoInfo["achievements"] == null) {
      _ngoInfo["achievements"] = [
        "Helped communities in need",
        "Provided essential services",
        "Organized awareness programs"
      ];
    }

    if (_ngoInfo["goals"] == null) {
      _ngoInfo["goals"] = [
        "Expand outreach to more communities",
        "Launch new sustainable initiatives",
        "Develop educational programs"
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : Colors.grey[100];
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280.0,
              floating: false,
              pinned: true,
              backgroundColor: primaryColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sharing NGO information')));
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Text(
                  _ngoInfo["name"],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // NGO image as background
                    Image.asset(
                      _ngoInfo["image"] ?? "assets/default_ngo.png",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: primaryColor.withOpacity(0.8),
                        child: Icon(Icons.image_not_supported,
                            color: Colors.white.withOpacity(0.5), size: 80),
                      ),
                    ),
                    // Gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // NGO summary information
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _ngoInfo["location"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              _buildInfoPill(Icons.people,
                                  "${_ngoInfo["volunteers"]} Volunteers"),
                              SizedBox(width: 8),
                              _buildInfoPill(
                                  Icons.star, "${_ngoInfo["rating"]} Rating"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(text: 'ABOUT'),
                  Tab(text: 'IMPACT'),
                  Tab(text: 'CONTACT'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAboutTab(),
            _buildImpactTab(),
            _buildContactTab(),
          ],
        ),
      ),
      // Action buttons as a bottom bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.volunteer_activism),
                  label: Text('VOLUNTEER'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Volunteer option selected'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.favorite),
                  label: Text('DONATE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Donate option selected'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPill(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // NGO description
        Text(
          _ngoInfo["about"],
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            height: 1.5,
          ),
        ),
        SizedBox(height: 16),
        Text(
          _ngoInfo["description"],
          style: TextStyle(
            fontSize: 14,
            color: textColor.withOpacity(0.7),
            height: 1.5,
          ),
        ),
        SizedBox(height: 24),

        // Mission & Vision section
        _buildSectionCard(
          title: "Mission & Vision",
          icon: Icons.lightbulb_outline,
          color: primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabeledText("Mission", _ngoInfo["mission"]),
              SizedBox(height: 16),
              _buildLabeledText("Vision", _ngoInfo["vision"]),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Progress section
        _buildSectionCard(
          title: "Fundraising Progress",
          icon: Icons.trending_up,
          color: Colors.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Goal: ${_ngoInfo["fundraising_goal"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "${_ngoInfo["progress"]}% Complete",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_ngoInfo["progress"] as int) / 100,
                  backgroundColor:
                      isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 8,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Current: ${_ngoInfo["donations_received"]}",
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Key statistics
        _buildSectionCard(
          title: "Key Statistics",
          icon: Icons.insert_chart_outlined,
          color: Colors.blue,
          child: Row(
            children: [
              _buildStatItem(
                value: "${_ngoInfo["beneficiaries"]}+",
                label: "Beneficiaries",
                color: Colors.blue,
              ),
              SizedBox(width: 16),
              _buildStatItem(
                value: "${_ngoInfo["projects"]}",
                label: "Projects",
                color: Colors.orange,
              ),
              SizedBox(width: 16),
              _buildStatItem(
                value: "Since ${_ngoInfo["founded"]}",
                label: "Operating",
                color: Colors.purple,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Achievements section
        _buildSectionCard(
          title: "Key Achievements",
          icon: Icons.emoji_events_outlined,
          color: Colors.orange,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...((_ngoInfo["achievements"] as List)
                  .map((achievement) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle,
                                size: 16, color: primaryColor),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                achievement.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList()),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Future goals section
        _buildSectionCard(
          title: "Future Goals",
          icon: Icons.flag_outlined,
          color: Colors.purple,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...((_ngoInfo["goals"] as List)
                  .map((goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right,
                                size: 20, color: primaryColor),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                goal.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList()),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLabeledText(String label, String content) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          // Section content
          Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImpactTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Impact distribution card
        _buildSectionCard(
          title: "Impact Distribution",
          icon: Icons.pie_chart_outline,
          color: primaryColor,
          child: Column(
            children: [
              SizedBox(height: 8),
              Text(
                "How resources are allocated across different areas",
                style: TextStyle(
                  fontSize: 13,
                  color: textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              _buildImpactChart(),
            ],
          ),
        ),
        SizedBox(height: 20),

        // Funding progress card
        _buildSectionCard(
          title: "Monthly Funding (₹ Millions)",
          icon: Icons.trending_up,
          color: Colors.green,
          child: Column(
            children: [
              SizedBox(height: 8),
              Text(
                "Funding trends over the past year",
                style: TextStyle(
                  fontSize: 13,
                  color: textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: _buildFundingChart(),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

        // Success stories card
        _buildSectionCard(
          title: "Success Stories",
          icon: Icons.auto_stories,
          color: Colors.orange,
          child: Column(
            children: [
              _buildSuccessStory(
                title: "Rural Education Initiative",
                subtitle: "Empowering 1,200+ children in rural villages",
                content:
                    "Our education initiatives have successfully provided quality education to over 1,200 children in remote villages. This program includes teacher training, infrastructure development, and educational resources.",
                imagePath: "assets/1.png",
              ),
              SizedBox(height: 16),
              _buildSuccessStory(
                title: "Healthcare Outreach Program",
                subtitle:
                    "Bringing essential healthcare to underserved communities",
                content:
                    "Our mobile medical units have served 5,000+ patients in remote areas, providing preventive care, treatments, and health education to communities with limited access to healthcare facilities.",
                imagePath: "assets/2.png",
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

        // Testimonials card
        _buildSectionCard(
          title: "Testimonials",
          icon: Icons.format_quote,
          color: Colors.purple,
          child: Column(
            children: [
              _buildTestimonial(
                quote:
                    "The impact this NGO has made in our village is remarkable. Our children now have access to quality education and healthcare.",
                author: "Priya Singh",
                role: "Village Council Member",
              ),
              Divider(height: 32),
              _buildTestimonial(
                quote:
                    "Their water conservation project transformed our community. We now have sustainable access to clean water year-round.",
                author: "Rajesh Kumar",
                role: "Community Leader",
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImpactChart() {
    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _impactData.length,
        itemBuilder: (context, index) {
          final data = _impactData[index];
          return Container(
            width: 120,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.color.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: data.percentage / 100,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(data.color),
                          strokeWidth: 8,
                        ),
                        Icon(data.icon, size: 30, color: data.color),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "${data.percentage.toInt()}%",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: data.color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  data.category,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFundingChart() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final gridColor = isDarkMode ? Colors.white12 : Colors.black12;

    // Find max value for scaling
    final maxValue = _fundingData.map((e) => e.amount).reduce(math.max);

    return Container(
      padding: EdgeInsets.only(top: 20, right: 20, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Y-axis labels
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${maxValue.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 10)),
              Text('${(maxValue * 0.75).toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 10)),
              Text('${(maxValue * 0.5).toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 10)),
              Text('${(maxValue * 0.25).toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 10)),
              Text('0.0', style: TextStyle(fontSize: 10)),
            ],
          ),
          SizedBox(width: 8),
          // Bars
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1, color: gridColor),
                  bottom: BorderSide(width: 1, color: gridColor),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _fundingData.map((data) {
                  // Calculate bar height based on value
                  final barHeight = (data.amount / maxValue) * 150;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 15,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(4)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primaryColor,
                              primaryColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        data.month.substring(0, 1), // First letter of month
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStory({
    required String title,
    required String subtitle,
    required String content,
    required String imagePath,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial({
    required String quote,
    required String author,
    required String role,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.format_quote,
          size: 24,
          color: primaryColor.withOpacity(0.5),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                author,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // Default values for contact info
    final phone = _ngoInfo["phone"] as String? ?? "N/A";
    final email = _ngoInfo["email"] as String? ?? "N/A";
    final website = _ngoInfo["website"] as String? ?? "N/A";

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Contact information card
        _buildSectionCard(
          title: "Contact Information",
          icon: Icons.contact_phone,
          color: primaryColor,
          child: Column(
            children: [
              _buildContactItem(
                icon: Icons.phone,
                title: "Phone",
                content: phone,
                onTap: () => phone != "N/A"
                    ? _launchPhone(phone)
                    : _showUnavailableDialog("Phone number"),
              ),
              Divider(height: 24),
              _buildContactItem(
                icon: Icons.email,
                title: "Email",
                content: email,
                onTap: () => email != "N/A"
                    ? _launchEmail(email, _ngoInfo["name"])
                    : _showUnavailableDialog("Email"),
              ),
              Divider(height: 24),
              _buildContactItem(
                icon: Icons.language,
                title: "Website",
                content: website.replaceFirst("https://", ""),
                onTap: () => website != "N/A"
                    ? _launchWebsite(website)
                    : _showUnavailableDialog("Website"),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

        // Office location card
        _buildSectionCard(
          title: "Office Location",
          icon: Icons.location_on,
          color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Main Office",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "123 Social Impact Avenue, ${_ngoInfo["location"]}",
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 48, color: Colors.grey[600]),
                      SizedBox(height: 8),
                      Text(
                        "Map Preview",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              OutlinedButton.icon(
                icon: Icon(Icons.directions),
                label: Text("GET DIRECTIONS"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor),
                  minimumSize: Size(double.infinity, 44),
                ),
                onPressed: () {
                  _launchMaps();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

        // Social media card
        _buildSectionCard(
          title: "Social Media",
          icon: Icons.public,
          color: Colors.blue,
          child: Column(
            children: [
              _buildSocialMediaButton(
                icon: Icons.facebook,
                platform: "Facebook",
                handle: "navajeevan.official",
                color: Color(0xFF3b5998),
              ),
              SizedBox(height: 12),
              _buildSocialMediaButton(
                icon: Icons.camera_alt,
                platform: "Instagram",
                handle: "@navajeevan_ngo",
                color: Color(0xFFc13584),
              ),
              SizedBox(height: 12),
              _buildSocialMediaButton(
                icon: Icons.messenger_outline,
                platform: "Twitter",
                handle: "@NavaJeevanNGO",
                color: Color(0xFF1DA1F2),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

        // Volunteer card
        _buildSectionCard(
          title: "How to Help",
          icon: Icons.volunteer_activism,
          color: Colors.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Join us in making a difference! There are several ways you can contribute to our mission:",
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(height: 8),
              _buildHelpOption(
                icon: Icons.people,
                title: "Volunteer Your Time",
                subtitle: "Join our volunteer program",
                primaryColor: primaryColor,
              ),
              SizedBox(height: 12),
              _buildHelpOption(
                icon: Icons.favorite,
                title: "Make a Donation",
                subtitle: "Support our projects financially",
                primaryColor: primaryColor,
              ),
              SizedBox(height: 12),
              _buildHelpOption(
                icon: Icons.campaign,
                title: "Spread the Word",
                subtitle: "Help raise awareness",
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: primaryColor,
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
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaButton({
    required IconData icon,
    required String platform,
    required String handle,
    required Color color,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon, color: color),
      label: Text(
        "$platform: $handle",
        style: TextStyle(color: color),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.3)),
        minimumSize: Size(double.infinity, 44),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $platform profile')),
        );
      },
    );
  }

  Widget _buildHelpOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color primaryColor,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: primaryColor,
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
                  color: textColor,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Show dialog when contact info is not available
  void _showUnavailableDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Not Available"),
          content: Text("$type is not available for this NGO."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // URL Launcher Methods
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', ''),
    );
    _launchUrl(phoneUri);
  }

  Future<void> _launchEmail(String email, String ngoName) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Inquiry about $ngoName',
        'body':
            'Hello,\n\nI am interested in learning more about $ngoName and how I can contribute to your mission.\n\nBest regards,\n',
      },
    );
    _launchUrl(emailUri);
  }

  Future<void> _launchWebsite(String url) async {
    final Uri webUri = Uri.parse(url);
    _launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchMaps() async {
    final location = Uri.encodeComponent(_ngoInfo["location"]);
    final Uri mapsUri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$location",
    );
    _launchUrl(mapsUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchUrl(Uri uri, {LaunchMode? mode}) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode ?? LaunchMode.platformDefault);
      } else {
        _showErrorSnackBar('Could not launch ${uri.toString()}');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching URL: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[700],
      ),
    );
  }
}
