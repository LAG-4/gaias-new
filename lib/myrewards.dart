import 'package:flutter/material.dart';
import 'package:gaia/requests.dart';

class MyRewards extends StatefulWidget {
  const MyRewards({Key? key}) : super(key: key);

  @override
  State<MyRewards> createState() => _MyRewardsState();
}

class _MyRewardsState extends State<MyRewards> {
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                SizedBox(height: 50,),
                Text(
                  "Total Reward Points",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance),
                    SizedBox(width: 10,),
                    Text(
                      "119",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 40
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30,),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestPage()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star),
                        SizedBox(width: 10,),
                        Text(
                          "Earn Points",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestPage()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.redeem, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text(
                          "Redeem Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
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
