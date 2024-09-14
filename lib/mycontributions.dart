import 'package:flutter/material.dart';

class MyContributions extends StatefulWidget {
  const MyContributions({Key? key}) : super(key: key);

  @override
  State<MyContributions> createState() => _MyContributionsState();
}

class _MyContributionsState extends State<MyContributions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        shape: Border(
          bottom: BorderSide(width: 2),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Center(child: Text("GAIA'S TOUCH",style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "My Contributions",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20,),

              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/contri1.png'),
                    SizedBox(width: 20,),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NGO: CRY Foundation",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                          ),
                        ),
                        Text(
                          "Contribution: Donation",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                        Text(
                          "Date: 20/08/24",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          "Points earned: 25",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/contri2.png'),
                    SizedBox(width: 20,),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hasirudala Foundation",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),
                        ),
                        Text(
                          "Contribution: Volunteer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                        Text(
                          "Date: 17/07/24",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          "Points earned: 32",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/contri3.png'),
                    SizedBox(width: 20,),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Akshaya Patra",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),
                        ),
                        Text(
                          "Contribution: Donation",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                        Text(
                          "Date: 28/10/23",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          "Points earned: 18",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
      ),
    );
  }
}
