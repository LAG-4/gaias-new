import 'package:flutter/material.dart';
import 'package:gaia/mycontributions.dart';
import 'package:gaia/myrewards.dart';
import 'package:gaia/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Custom clipper for full-height drawer
class _DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
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
        shape: Border(
          bottom: BorderSide(width: 2, color: Colors.teal[400]!),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "GAIA'S TOUCH",
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
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 60,
      drawer: ClipPath(
        clipper: _DrawerClipper(),
        child: Drawer(
          width: MediaQuery.of(context).size.width * 0.85,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.teal[300]!,
                      Colors.teal[400]!,
                      Colors.teal[600]!,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Welcome, LAG',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading:
                    const Icon(Icons.volunteer_activism, color: Colors.teal),
                title: Text(
                  'My Contributions',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyContributions()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard, color: Colors.teal),
                title: Text(
                  'My Reward Points',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyRewards()),
                  );
                },
              ),
              Divider(
                color: Colors.teal.withOpacity(0.3),
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.teal,
                ),
                title: Text(
                  themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: Colors.teal,
                  activeTrackColor: Colors.teal.withOpacity(0.3),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.withOpacity(0.3),
                ),
                onTap: () {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextField(
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontFamily: 'Inter'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2C2C2C)
                      : Colors.grey[200],
                  labelText: 'Search',
                  labelStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Inter'),
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal[400]!),
                  ),
                ),
              ),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[0]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog1();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[1]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog2();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[2]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog3();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[3]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog4();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[4]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog5();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[5]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog6();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[6]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog7();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[7]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog8();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[8]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog9();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[9]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog10();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[10]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog11();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[11]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog12();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[12]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog13();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[13]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog14();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[14]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog15();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[15]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog16();
                  },
                ),
                InkWell(
                  child: Image(
                    image: AssetImage(imageList[16]),
                    height: 100,
                  ),
                  onTap: () {
                    openDialog17();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future openDialog1() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '1. NO POVERTY',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'ActionAid',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CARE',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Oxfam',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Save the Children',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Smile Foundation',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog2() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '2. ZERO HUNGER',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'AP Foundation',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Goonj',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'ANNM Foun.',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Food Bank India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Feeding India ',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog3() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '3. GOOD HEALTH & WELL-BEING',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'BnM Foun.',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Smile Foundation',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'AP Foundation ',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'PE Foundation',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'SankaraEye Foun.',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog4() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '4. QUALITY EDUCATION',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Teach For India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'PE Foun. ',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Akanksha Found.',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'RTR India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Bhumi',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog5() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '5. GENDER EQUALITY',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'BT India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Oxfam India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CREA',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CARE India ',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Jagori',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog6() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '6. CLEAN WATER & SANITATION',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WaterAid India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WASH United ',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Water.org',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Gram Vikas',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Sulabh',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog7() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '7. AFFORDABLE & CLEAN ENERGY',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'TERI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CEEW',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'PEG',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'SELCO',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Vasudha',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog8() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '8. DECENT WORK & ECONOMIC GROWTH',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'SEWA',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Pradan',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'GRAVIS',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CEC',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'ASA',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog9() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '9. INDUSTRY, INNOVATION & INFRASTRUCTURE',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'ISABP',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CSE',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CII',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'TERI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'DEG',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog10() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '10. REDUCED INEQUALITIES',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Oxfam India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'ActionAid India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Save the Children',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CRY',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'PE',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog11() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '11. SUSTAINABLE CITIES & COMMUNITIES',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'TERI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CSE',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Clean Air Asia',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'IIHS',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WRI India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog12() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '12. RESPONSIBLE CONSUMPTION & PRODUCTION',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CSE',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Toxics Link',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'IPCA',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WCSI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'TERI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog13() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '13. CLIMATE ACTION',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'THE CGI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CSE',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WWF',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Greenpeace India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'IYCN',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog14() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '14. LIFE BELOW WATER',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'The Nature',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WWF',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WTI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'RWMC',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'OCI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog15() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '15. LIFE ON LAND',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WWF',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WTI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Greenpeace India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'WCS',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CSE',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog17() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '17. PARTNERSHIPS FOR THE GOALS',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Social Justice',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'HRLN',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Navsarjan Trust',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: "People's Watch",
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CHRI',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
  Future openDialog16() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '16. PEACE, JUSTICE AND STRONG INSTITUTIONS',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal[400]!, width: 2),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'CRY',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Oxfam India',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'Save the Children',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'APF',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedButtonWidget(
                      buttonText: 'PEF',
                      width: double.infinity,
                      onpressed: () {},
                      onpressed2: () {},
                    ),
                  ),
                ],
              ),
            ),
          ));
}

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final double width;
  final Function onpressed;
  final Function onpressed2;

  RoundedButtonWidget({
    required this.buttonText,
    required this.width,
    required this.onpressed,
    required this.onpressed2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.teal.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 8.0)
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            colors: [
              Color(0xFF2C2C2C),
              Color(0xFF212121),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal[400]!, width: 1),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(width, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            onpressed();
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    onpressed2();
                  },
                  child: Text(
                    'CONTACT',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.teal[400]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
