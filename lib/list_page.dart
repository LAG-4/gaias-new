import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaia/analytics.dart';
import 'package:gaia/base_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // final _firestore = FirebaseFirestore.instance;
  // final _auth = FirebaseAuth.instance;

  // Hardcoded list of cities to simulate location selection
  final List<String> _cities = [
    "BENGALURU",
    "MUMBAI",
    "DELHI",
    "CHENNAI",
    "KOLKATA",
    "HYDERABAD",
    "VIJAYAWADA"
  ];

  String _cityName = "BENGALURU"; // Default city
  bool _isLoading = false;

  // NGO data for each card
  final List<Map<String, dynamic>> _ngoData = [
    {
      "image": "assets/1.png",
      "name": "Navajeevan Bala Bhavan",
      "location": "Vijayawada",
      "about": "Supporting children's education and welfare",
      "volunteers": 120,
      "rating": 4.8
    },
    {
      "image": "assets/2.png",
      "name": "Save The Children",
      "location": "Multiple Locations",
      "about":
          "Focused on improving children's lives through better education, health care, and economic opportunities",
      "volunteers": 450,
      "rating": 4.7
    },
    {
      "image": "assets/3.png",
      "name": "World Vision",
      "location": "Pan India",
      "about":
          "Dedicated to helping children, families, and communities overcome poverty and injustice",
      "volunteers": 320,
      "rating": 4.5
    },
    {
      "image": "assets/4.png",
      "name": "CRY - Child Rights and You",
      "location": "National",
      "about":
          "Working to ensure children's rights to survival, development, protection and participation",
      "volunteers": 280,
      "rating": 4.6
    },
    {
      "image": "assets/5.png",
      "name": "Smile Foundation",
      "location": "Multiple Cities",
      "about":
          "Working for the welfare of children, their families, and communities",
      "volunteers": 300,
      "rating": 4.4
    },
    {
      "image": "assets/6.png",
      "name": "ActionAid India",
      "location": "National",
      "about":
          "Working with vulnerable communities to fight poverty and injustice",
      "volunteers": 240,
      "rating": 4.2
    },
  ];

  List<Map<String, dynamic>> _filteredNGOs = [];

  @override
  void initState() {
    super.initState();
    // Simulate getting a random city from the list to demonstrate dynamic city selection
    _selectRandomCity();
  }

  // Simulate location detection with a random city selection
  void _selectRandomCity() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(Duration(seconds: 1), () {
      // Check if widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          // Select a random city from the list
          _cityName = _cities[DateTime.now().millisecond % _cities.length];
          _isLoading = false;

          // Filter NGOs based on selected city
          _filterNGOs();
        });
      }
    });
  }

  // Filter NGOs based on selected city
  void _filterNGOs() {
    setState(() {
      if (_cityName == "VIJAYAWADA") {
        // For Vijayawada, show only Navajeevan Bala Bhavan
        _filteredNGOs =
            _ngoData.where((ngo) => ngo["location"] == "Vijayawada").toList();
      } else if (_cityName == "NATIONAL") {
        // For "National", show all NGOs
        _filteredNGOs = _ngoData;
      } else {
        // For other cities, show a mix based on "location" field containing the city or "Multiple"
        _filteredNGOs = _ngoData
            .where((ngo) =>
                ngo["location"].toString().contains("Multiple") ||
                ngo["location"].toString().contains("National") ||
                ngo["location"].toString().contains("Pan") ||
                ngo["location"].contains(_titleCase(_cityName)))
            .toList();
      }
    });
  }

  // Helper to convert "UPPERCASE" to "Titlecase"
  String _titleCase(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Change to a different city
  void _changeCity() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF1E1E1E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_city, color: Colors.teal),
                    SizedBox(width: 10),
                    Text(
                      'Select Your City',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  width: double.maxFinite,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    itemCount: _cities.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected = _cities[index] == _cityName;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _cityName = _cities[index];
                            _filterNGOs();
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.teal.withOpacity(0.2)
                                : Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color(0xFF2C2C2C)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: Colors.teal, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              _cities[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.teal
                                    : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ACTIVE NGO'S IN YOUR LOCATION:",
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18,
                        fontFamily: 'InterBlack'),
                  ),
                  // City name with change location option
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isLoading ? "Loading..." : _cityName,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 26,
                            fontFamily: 'InterBlack',
                          ),
                        ),
                      ),
                      if (_isLoading)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.teal,
                          ),
                        ),
                      if (!_isLoading)
                        IconButton(
                          icon: Icon(Icons.location_on, color: Colors.teal),
                          onPressed: _changeCity,
                          tooltip: "Change Location",
                        ),
                    ],
                  ),

                  // Location selection help text
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                    child: Text(
                      "Tap the location icon to change your city",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NGO Card list
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                      ),
                    )
                  : _filteredNGOs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No NGOs found in $_cityName",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _changeCity,
                                child: Text("Change Location"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredNGOs.length,
                          itemBuilder: (context, index) {
                            final ngo = _filteredNGOs[index];
                            return NGOCard(
                              ngo: ngo,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AnalyticsPage(ngoData: ngo),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class NGOCard extends StatelessWidget {
  final Map<String, dynamic> ngo;
  final VoidCallback onTap;

  const NGOCard({
    Key? key,
    required this.ngo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF1E1E1E)
          : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NGO Image with gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    ngo["image"],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Text(
                      ngo["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 4),
                      Text(
                        ngo["location"],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 4),
                          Text(
                            ngo["rating"].toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // About text
                  Text(
                    ngo["about"],
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  // Volunteers
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${ngo["volunteers"]} Volunteers",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      // View details button
                      TextButton.icon(
                        onPressed: onTap,
                        icon: Icon(
                          Icons.analytics,
                          size: 16,
                          color: Colors.teal,
                        ),
                        label: Text(
                          "View Details",
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 14,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
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

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.img});

  final String img;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        splashColor: Colors.black26,
        onTap: () {},
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Image(
                  image: NetworkImage(
                    img,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
