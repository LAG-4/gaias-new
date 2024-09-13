import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({Key? key}) : super(key: key);



  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {


  List imageList=[
    "assets/n1.jpg",
    "assets/b.jpg",
    "assets/c.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(width: 2),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Center(child: Text("GAIA'S TOUCH",style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('COMMUNITY',style: TextStyle(color: Colors.black,fontSize: 28,fontFamily: 'InterBlack'),),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset('assets/u1.jpg'),
                        ),
                        SizedBox(width: 15,),
                        const Text(
                          "Shwet Siwach made a \ndifference today!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    height: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "17 measures undertaken by NGOs,\n communities in India contributing to SDGs",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Image.asset('assets/n1.jpg')

                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset('assets/u2.jpg'),
                        ),
                        const SizedBox(width: 15,),
                        const Text(
                          "Anurag Yadav made a \ndifference today!",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NGOs, volunteers reach out to feed\n Bengaluru's hungry",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 10,),
                        Image.asset('assets/n2.jpg')
                      ],
                    ),
                  ),
                ),

                //THIS CODE RUNS PERFECTLY
                //BELOW IS THE WORKING FIREBASE CODE BUT DUE TO INTERNET ISSUES WIDGETS WERENT LOADING FAST
                //THIS IS WHY WE DECIDED TO USE ASSET IMAGES FOR PRESENTATION PURPOSES BUT OUR MAIN GOAL WAS USING FIREBASE ITSELF
                // Padding(
                //   padding: const EdgeInsets.all(0.0),
                //   child: StreamBuilder(
                //     stream: _firestore.collection('request').snapshots(),
                //     builder: (context,snapshot){
                //       final messages = snapshot.data?.docs;
                //       List<MessageBubble> messageBubbles=[];
                //       for(var message in messages!){
                //         final img = message.data()['img'];
                //
                //         final card = MessageBubble(img: img,
                //         );
                //         messageBubbles.add(card);
                //       }
                //
                //       return Expanded(
                //         child: Padding(
                //           padding: const EdgeInsets.all(15.0),
                //           child: Column(
                //             children: messageBubbles,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

