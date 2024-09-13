import 'package:flutter/material.dart';
import 'package:gaia/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('GAIAS',style: TextStyle(color: Colors.black,fontSize: 40,fontFamily: 'Habibi'),),
                      Text('TOUCH',style: TextStyle(color: Colors.black,fontSize: 40,fontFamily: 'Habibi'),),
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
                    color: Colors.red,
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.g_mobiledata_rounded),color: Colors.white,),
                      TextButton(child:const Text('Sign in With Google',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DamnTime()));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
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
