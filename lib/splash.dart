import 'package:flutter/material.dart';
import 'package:hive_practice/home.dart';
import 'package:hive_practice/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    navigateToLogin();
  }
  void navigateToLogin()async{
    await Future.delayed(Duration(seconds: 3));
    final prefs=await SharedPreferences.getInstance();
    bool isLoggedIn=prefs.getBool("isLoggedIn")??false;
    if(!mounted)return;
    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Home()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Login()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flutter_dash,
          size: 100,
          color: Colors.blue,
          )
        ],
      ),
    ),
    );
  }
}