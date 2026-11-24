import 'package:flutter/material.dart';
import 'package:hive_practice/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final username=TextEditingController();
  final password=TextEditingController();
  void login()async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString("username", username.text);
    await prefs.setString("password", password.text);
    await prefs.setBool("isLoggedIn", true);
    if(!mounted)return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Home()));
  }
  @override
  void dispose(){
    username.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Center(
   child: Padding(padding: EdgeInsets.all(12),
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: username,
          decoration: InputDecoration(
            hintText: "Enter username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
            )
          ),
        ),
    SizedBox(height: 10,),
        TextField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Enter password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
          )
        ),
      ),
    SizedBox(height: 15,),
      ElevatedButton(onPressed: (){
        if(username.text.isEmpty||password.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("enter username and password")));
            }else{
            login();
          }
        },
            child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}