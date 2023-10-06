import 'package:digitally_unchained/collections/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  Future<void> save_data() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    //await prefs.setString('email', emailController.text);
    //await prefs.setString('password', passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(BACKGROUND_COLOR),
    );
  }
}
