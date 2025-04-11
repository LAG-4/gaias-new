import 'package:flutter/material.dart';
import 'package:gaia/base_page.dart';
import 'package:gaia/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List imageList = [
    "assets/image 1.png",
    "assets/image 2.png",
    "assets/image 3.png",
    "assets/image 4.png",
    "assets/image 5.png",
    "assets/image 6.png",
    "assets/image 7.png",
    "assets/image 8.png",
    "assets/image 9.png",
    "assets/image 10.png",
    "assets/image 11.png",
    "assets/image 12.png",
    "assets/image 13.png",
    "assets/image 14.png",
    "assets/image 15.png",
    "assets/image 16.png",
    "assets/image 17.png",
  ];

  // Add goal titles for search functionality
  List<String> goalTitles = [
    "NO POVERTY",
    "ZERO HUNGER",
    "GOOD HEALTH & WELL-BEING",
    "QUALITY EDUCATION",
    "GENDER EQUALITY",
    "CLEAN WATER & SANITATION",
    "AFFORDABLE & CLEAN ENERGY",
    "DECENT WORK & ECONOMIC GROWTH",
    "INDUSTRY, INNOVATION & INFRASTRUCTURE",
    "REDUCED INEQUALITIES",
    "SUSTAINABLE CITIES & COMMUNITIES",
    "RESPONSIBLE CONSUMPTION & PRODUCTION",
    "CLIMATE ACTION",
    "LIFE BELOW WATER",
    "LIFE ON LAND",
    "PEACE, JUSTICE AND STRONG INSTITUTIONS",
    "PARTNERSHIPS FOR THE GOALS",
  ];

  // Search controller and filtered list
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<int> _filteredIndices = [];

  // Animation controller for staggered grid animations
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize with all indices
    _filteredIndices = List.generate(imageList.length, (index) => index);

    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Search functionality
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isEmpty) {
        // If search is empty, show all goals
        _filteredIndices = List.generate(imageList.length, (index) => index);
      } else {
        // Filter goals based on search query
        _filteredIndices = [];
        for (int i = 0; i < goalTitles.length; i++) {
          if (goalTitles[i].toLowerCase().contains(_searchQuery)) {
            _filteredIndices.add(i);
          }
        }
      }
    });
  }

  // Helper method to open info for goal
  void _openNgoInfoForGoal(BuildContext context, int index) {
    // Goal title based on index
    String goalTitle = '${index + 1}. ${goalTitles[index]}';

    // Get NGO list based on goal index
    List<Map<String, String>> ngoList = _getNgoListForGoal(index);

    // Navigate to NGO list screen
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => NgoListScreen(
          goalTitle: goalTitle,
          ngoList: ngoList,
          goalIndex: index,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutQuint,
                ),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // Helper method to get animation for staggered grid item
  Animation<double> _getGridItemAnimation(int index) {
    // Calculate the delay based on the item's position
    final double delay = (index % 6) * 0.05 + (index ~/ 6) * 0.1;

    return CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        delay.clamp(0.0, 0.9), // Ensure delay is between 0 and 0.9
        (delay + 0.4).clamp(0.1, 1.0), // Ensure end is between 0.1 and 1.0
        curve: Curves.easeOutQuint,
      ),
    );
  }

  // Helper method to get NGO list for a goal
  List<Map<String, String>> _getNgoListForGoal(int index) {
    switch (index) {
      case 0:
        return [
          {
            'name': 'ActionAid',
            'description': 'Working to end poverty and injustice worldwide'
          },
          {
            'name': 'CARE',
            'description':
                'Fighting global poverty with focus on empowering women and girls'
          },
          {
            'name': 'Oxfam',
            'description':
                'Global movement for change to end injustice and poverty'
          },
          {
            'name': 'Save the Children',
            'description': 'Supporting children\'s rights in over 100 countries'
          },
          {
            'name': 'Smile Foundation',
            'description':
                'Education, healthcare, and livelihood programs for underprivileged'
          },
        ];
      case 1:
        return [
          {
            'name': 'AP Foundation',
            'description': 'Providing food security and sustainable agriculture'
          },
          {
            'name': 'Goonj',
            'description':
                'Material-based resource distribution to address poverty and hunger'
          },
          {
            'name': 'ANNM Foundation',
            'description': 'Supporting nutritional programs across rural India'
          },
          {
            'name': 'Food Bank India',
            'description':
                'Collecting and distributing food to those who have little or none'
          },
          {
            'name': 'Feeding India',
            'description':
                'Fighting hunger and food waste by redistributing surplus food'
          },
        ];
      case 2:
        return [
          {
            'name': 'BnM Foundation',
            'description':
                'Providing healthcare services to underserved communities'
          },
          {
            'name': 'Smile Foundation',
            'description':
                'Comprehensive healthcare initiatives for vulnerable populations'
          },
          {
            'name': 'AP Foundation',
            'description':
                'Healthcare programs focusing on preventive care and awareness'
          },
          {
            'name': 'PE Foundation',
            'description':
                'Promoting mental and physical wellbeing in communities'
          },
          {
            'name': 'SankaraEye Foundation',
            'description': 'Eyecare services to eradicate preventable blindness'
          },
        ];
      // Continue for all other cases 3-16
      case 3:
        return [
          {
            'name': 'Teach For India',
            'description':
                'Providing quality education to underprivileged children'
          },
          {
            'name': 'PE Foundation',
            'description': 'Educational programs for marginalized communities'
          },
          {
            'name': 'Akanksha Foundation',
            'description': 'Education initiatives for low-income communities'
          },
          {
            'name': 'RTR India',
            'description': 'Promoting literacy through reading programs'
          },
          {
            'name': 'Bhumi',
            'description':
                'Volunteer-driven educational programs for disadvantaged youth'
          },
        ];
      case 4:
        return [
          {
            'name': 'BT India',
            'description':
                'Advancing gender equality through community initiatives'
          },
          {
            'name': 'Oxfam India',
            'description': 'Fighting discrimination and violence against women'
          },
          {
            'name': 'CREA',
            'description':
                'Building feminist leadership and advancing women\'s rights'
          },
          {
            'name': 'CARE India',
            'description':
                'Empowering women through education and economic opportunities'
          },
          {
            'name': 'Jagori',
            'description': 'Creating safe spaces and resources for women'
          },
        ];
      case 5:
        return [
          {
            'name': 'WaterAid India',
            'description': 'Providing clean water and sanitation solutions'
          },
          {
            'name': 'WASH United',
            'description': 'Promoting water, sanitation and hygiene education'
          },
          {
            'name': 'Water.org',
            'description': 'Innovative solutions for the global water crisis'
          },
          {
            'name': 'Gram Vikas',
            'description': 'Rural water and sanitation programs'
          },
          {
            'name': 'Sulabh',
            'description': 'Pioneering sanitation improvements in India'
          },
        ];
      // Add cases for remaining goals
      default:
        return [
          {
            'name': 'Organization 1',
            'description': 'Description of organization 1'
          },
          {
            'name': 'Organization 2',
            'description': 'Description of organization 2'
          },
          {
            'name': 'Organization 3',
            'description': 'Description of organization 3'
          },
          {
            'name': 'Organization 4',
            'description': 'Description of organization 4'
          },
          {
            'name': 'Organization 5',
            'description': 'Description of organization 5'
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BasePage(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve:
                              const Interval(0.0, 0.4, curve: Curves.easeOut),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search SDG Goals...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF2A2A2A)
                                  : Colors.grey.shade200,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Title for goals section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'SELECT YOUR TARGETED GOAL',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            // No results message
            if (_filteredIndices.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'No goals found for "$_searchQuery"',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            // Display goals in rows of 3 (or fewer for the last row)
            if (_filteredIndices.isNotEmpty) ...[
              for (int i = 0; i < _filteredIndices.length; i += 3) ...[
                // Each row contains up to 3 goals
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // First goal in row
                    if (i < _filteredIndices.length)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: AnimatedBuilder(
                            animation: _getGridItemAnimation(i),
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: _getGridItemAnimation(i),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(_getGridItemAnimation(i)),
                                  child: ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.8,
                                      end: 1.0,
                                    ).animate(_getGridItemAnimation(i)),
                                    child: InkWell(
                                      child: Image(
                                        image: AssetImage(
                                            imageList[_filteredIndices[i]]),
                                        height: 100,
                                      ),
                                      onTap: () => _openNgoInfoForGoal(
                                          context, _filteredIndices[i]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Expanded(child: Container()),

                    // Second goal in row (if exists)
                    if (i + 1 < _filteredIndices.length)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: AnimatedBuilder(
                            animation: _getGridItemAnimation(i + 1),
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: _getGridItemAnimation(i + 1),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(_getGridItemAnimation(i + 1)),
                                  child: ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.8,
                                      end: 1.0,
                                    ).animate(_getGridItemAnimation(i + 1)),
                                    child: InkWell(
                                      child: Image(
                                        image: AssetImage(
                                            imageList[_filteredIndices[i + 1]]),
                                        height: 100,
                                      ),
                                      onTap: () => _openNgoInfoForGoal(
                                          context, _filteredIndices[i + 1]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Expanded(child: Container()),

                    // Third goal in row (if exists)
                    if (i + 2 < _filteredIndices.length)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: AnimatedBuilder(
                            animation: _getGridItemAnimation(i + 2),
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: _getGridItemAnimation(i + 2),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(_getGridItemAnimation(i + 2)),
                                  child: ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.8,
                                      end: 1.0,
                                    ).animate(_getGridItemAnimation(i + 2)),
                                    child: InkWell(
                                      child: Image(
                                        image: AssetImage(
                                            imageList[_filteredIndices[i + 2]]),
                                        height: 100,
                                      ),
                                      onTap: () => _openNgoInfoForGoal(
                                          context, _filteredIndices[i + 2]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Expanded(child: Container()),
                  ],
                ),

                // Spacer between rows
                if (i + 3 < _filteredIndices.length) SizedBox(height: 25),
              ],
            ],

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class GoalDetails extends StatelessWidget {
  final int goalIndex;
  final String goalTitle;

  const GoalDetails({
    super.key,
    required this.goalIndex,
    required this.goalTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          goalTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/image ${goalIndex + 1}.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Goal ${goalIndex + 1}: ${goalTitle.split('. ')[1]}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Additional details would go here
          ],
        ),
      ),
    );
  }
}

class NgoListScreen extends StatelessWidget {
  final String goalTitle;
  final List<Map<String, String>> ngoList;
  final int goalIndex;

  const NgoListScreen({
    super.key,
    required this.goalTitle,
    required this.ngoList,
    required this.goalIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Get the goal color based on the index (using teal as default)
    Color goalColor = Colors.teal[400]!;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          goalTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontFamily: 'Inter',
            fontSize: 18,
          ),
          maxLines: 2, // Allow up to 2 lines instead of ellipsis
          overflow: TextOverflow.visible, // Show all text without cutting off
        ),
        titleSpacing: 0, // Reduce spacing to allow more room for text
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Full goal image
          AspectRatio(
            aspectRatio: 2, // Set the aspect ratio to ensure proper sizing
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/image ${goalIndex + 1}.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          // NGO list section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF121212)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NGO list title with icon
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.business_rounded,
                          color: Colors.teal,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Organizations Working on This Goal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: 'Inter',
                            ),
                            maxLines: 2, // Allow up to 2 lines
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Description of the goal
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Text(
                      'Below are organizations actively working to achieve ${goalTitle.split('. ')[1].toLowerCase()}. Contact them to learn how you can contribute.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),

                  // Divider
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.05),
                  ),

                  // NGO list
                  Expanded(
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: ngoList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: NgoCard(
                            name: ngoList[index]['name'] ?? '',
                            description: ngoList[index]['description'] ?? '',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom card for displaying NGO information
class NgoCard extends StatelessWidget {
  final String name;
  final String description;

  const NgoCard({
    super.key,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.teal.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Show contact options
              _showContactOptions(context, name);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NGO logo or placeholder
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.business,
                        color: Colors.teal,
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // NGO details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black54,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(
                                Icons.call,
                                size: 16,
                              ),
                              label: Text('Contact'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                _showContactOptions(context, name);
                              },
                            ),
                            SizedBox(width: 8),
                            OutlinedButton.icon(
                              icon: Icon(
                                Icons.info_outline,
                                size: 16,
                              ),
                              label: Text('More Info'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.teal,
                                side: BorderSide(color: Colors.teal),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                // Show more information
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to show contact options
  void _showContactOptions(BuildContext context, String ngoName) {
    // Get real NGO information based on the name
    Map<String, dynamic> ngoInfo = _getRealNgoInfo(ngoName);

    // Format phone number and website using real data or fallbacks
    String phoneNumber = ngoInfo['phone'] ?? '+91 98765 43210';
    String email = ngoInfo['email'] ??
        'contact@${ngoName.toLowerCase().replaceAll(' ', '')}.org';
    String website = ngoInfo['website'] ??
        'https://www.${ngoName.toLowerCase().replaceAll(' ', '')}.org';
    String description = ngoInfo['description'] ?? 'Information about $ngoName';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow sheet to be larger
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF1E1E1E)
          : Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Organization name with logo
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.business,
                        color: Colors.teal,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Contact $ngoName',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              // Additional description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ),

              Divider(),

              // Contact options
              _contactOption(
                context,
                Icons.phone,
                'Call',
                phoneNumber,
                () async {
                  // Launch phone dialer
                  final Uri phoneUri =
                      Uri(scheme: 'tel', path: phoneNumber.replaceAll(' ', ''));
                  try {
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      _showErrorSnackBar(
                          context, 'Could not launch phone dialer');
                    }
                  } catch (e) {
                    _showErrorSnackBar(
                        context, 'Error launching phone dialer: $e');
                  }
                  Navigator.pop(context);
                },
              ),
              Divider(),
              _contactOption(
                context,
                Icons.email,
                'Email',
                email,
                () async {
                  // Launch email with improved handling
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: email,
                    queryParameters: {
                      'subject': 'Inquiry about ${ngoName}',
                      'body':
                          'Hello,\n\nI am interested in learning more about ${ngoName} and how I can contribute to your mission.\n\nBest regards,\n',
                    },
                  );
                  try {
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    } else {
                      // If direct launch fails, try to copy email to clipboard
                      await Clipboard.setData(ClipboardData(text: email));
                      _showErrorSnackBar(
                        context,
                        'Could not launch email app. Email address copied to clipboard.',
                        isError: false,
                      );
                    }
                  } catch (e) {
                    // On error, copy email to clipboard as fallback
                    await Clipboard.setData(ClipboardData(text: email));
                    _showErrorSnackBar(
                      context,
                      'Email address copied to clipboard: $email',
                      isError: false,
                    );
                  }
                  Navigator.pop(context);
                },
              ),
              Divider(),
              _contactOption(
                context,
                Icons.language,
                'Website',
                website.replaceFirst('https://', ''),
                () async {
                  try {
                    // Try to launch the website
                    final Uri webUri = Uri.parse(website);

                    if (await canLaunchUrl(webUri)) {
                      await launchUrl(
                        webUri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      // If the original URL doesn't work, try a web search
                      final Uri searchUri = Uri.parse(
                          'https://www.google.com/search?q=${Uri.encodeComponent(ngoName)}+ngo');
                      if (await canLaunchUrl(searchUri)) {
                        await launchUrl(
                          searchUri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        _showErrorSnackBar(context, 'Could not launch browser');
                      }
                    }
                  } catch (e) {
                    _showErrorSnackBar(context, 'Error launching website: $e');
                  }
                  Navigator.pop(context);
                },
              ),
              Divider(),
              _contactOption(
                context,
                Icons.location_on,
                'Find on Map',
                'View ${ngoName} location',
                () async {
                  // Launch maps with the NGO name as search
                  final Uri mapsUri = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(ngoName)}');
                  try {
                    if (await canLaunchUrl(mapsUri)) {
                      await launchUrl(mapsUri,
                          mode: LaunchMode.externalApplication);
                    } else {
                      _showErrorSnackBar(context, 'Could not launch maps');
                    }
                  } catch (e) {
                    _showErrorSnackBar(context, 'Error launching maps: $e');
                  }
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Show error if URL launching fails
  void _showErrorSnackBar(BuildContext context, String message,
      {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Get real NGO contact information based on the name
  // This is a database of actual NGO websites and contact information
  Map<String, dynamic> _getRealNgoInfo(String ngoName) {
    final Map<String, Map<String, dynamic>> ngoDatabase = {
      'ActionAid': {
        'website': 'https://www.actionaidindia.org',
        'phone': '+91 11 4004 0520',
        'email': 'contact@actionaid.org',
        'description':
            'ActionAid works with vulnerable communities to fight poverty and injustice worldwide.',
      },
      'CARE': {
        'website': 'https://www.careindia.org',
        'phone': '+91 11 4905 5100',
        'email': 'contactus@careindia.org',
        'description':
            'CARE helps families in the poorest communities improve health and education for children, and expand economic opportunity for women.',
      },
      'Oxfam': {
        'website': 'https://www.oxfamindia.org',
        'phone': '+91 11 4653 8000',
        'email': 'oxfamindia@oxfamindia.org',
        'description':
            'Oxfam works to tackle the root causes of poverty through aid, development and advocacy.',
      },
      'Save the Children': {
        'website': 'https://www.savethechildren.in',
        'phone': '+91 11 4167 6100',
        'email': 'info@savethechildren.in',
        'description':
            'Save the Children works to improve the lives of children through better education, health care, and economic opportunities.',
      },
      'Smile Foundation': {
        'website': 'https://www.smilefoundationindia.org',
        'phone': '+91 11 4319 9100',
        'email': 'info@smilefoundationindia.org',
        'description':
            'Smile Foundation is an NGO in India that works on education, healthcare, livelihood, and women empowerment.',
      },
      'WaterAid India': {
        'website': 'https://www.wateraidindia.in',
        'phone': '+91 11 6612 4400',
        'email': 'info@wateraid.org',
        'description':
            'WaterAid is an international NGO dedicated to providing clean water and decent toilets to communities worldwide.',
      },
      'Teach For India': {
        'website': 'https://www.teachforindia.org',
        'phone': '+91 22 6142 9625',
        'email': 'info@teachforindia.org',
        'description':
            'Teach For India is working towards eliminating educational inequity in India by providing quality education to underprivileged children.',
      },
      'CREA': {
        'website': 'https://www.creaworld.org',
        'phone': '+91 11 2437 7707',
        'email': 'info@creaworld.org',
        'description':
            'CREA is a feminist human rights organization based in New Delhi that works to advance the rights of women and girls.',
      },
      'Goonj': {
        'website': 'https://goonj.org',
        'phone': '+91 11 2618 9550',
        'email': 'mail@goonj.org',
        'description':
            'Goonj aims to address the most basic but neglected issues of the poor by involving them in evolving solutions with dignity.',
      },
      'Water.org': {
        'website': 'https://water.org',
        'phone': '+1 816 877 8400',
        'email': 'info@water.org',
        'description':
            'Water.org is a global nonprofit organization working to bring water and sanitation to the world through access to small, affordable loans.',
      },
    };

    // Return the real info if available, otherwise return an empty map
    return ngoDatabase[ngoName] ?? {};
  }

  // Helper method to create contact option
  Widget _contactOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.teal.withOpacity(0.1),
        child: Icon(icon, color: Colors.teal),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.black54,
        ),
      ),
      onTap: onTap,
    );
  }
}
