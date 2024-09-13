import 'package:flutter/material.dart';
import 'package:gaia/homepage.dart';

import 'navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(width: 2),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Center(child: Text("GAIA'S TOUCH",style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),)),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 150,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('GAIAS',style: TextStyle(color: Colors.white,fontSize: 40,fontFamily: 'Habibi', fontWeight: FontWeight.bold),),
                      Text('TOUCH',style: TextStyle(color: Colors.white,fontSize: 40,fontFamily: 'Habibi', fontWeight: FontWeight.bold),),
                    ],
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset('assets/img.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pink,
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.g_mobiledata_rounded),color: Colors.white,),
                      TextButton(child:const Text('Sign in With Google',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DamnTime()));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const HomePage()),
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
