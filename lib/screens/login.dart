import 'package:digitally_unchained/collections/user_messages.dart';
import 'package:digitally_unchained/screens/home.dart';
import 'package:digitally_unchained/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitally_unchained/collections/colors.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:digitally_unchained/collections/my_functions.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email, password;
  bool shouldShowEmailValidationText = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unfocusWidgets(context);
      },
      child: Scaffold(
        backgroundColor: Color(BACKGROUND_COLOR),
        body: ListView(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.all(20),
                      height: 220,
                      child: Image.asset('images/du_logo_dark.png')),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 24),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login with your email',
                      style: titleTextStyle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DarkTextField(
                      textController: emailController,
                      label: 'Email address',
                      onTextChanged: validateEmailFormat,
                    ),
                  ),
                  SizedBox(height: 10, width: double.infinity),
                  TextFieldValidationWarning(
                      shouldShow: shouldShowEmailValidationText, message: EMAIL_VALIDATION_WARNING_TEXT,),
                  SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  Container(
                    // Password TextField
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DarkTextField(
                      label: 'Password',
                      textController: passwordController,
                      hasObscureText: false,
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    width: 1000,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        validateEmailPassword();
                      },
                      child: Text(
                        'CONTINUE',
                        style: buttonTextTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(height: 32, width: double.infinity),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Don't have an account?",
                      style: suggestionTextStyle,
                    ),
                  ),
                  SizedBox(height: 12, width: double.infinity),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Register();
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SIGN UP',
                        style: textButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> validateEmailPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? correctEmail = await prefs.getString('email');
    String? correctPassword = await prefs.getString('password');

    email = emailController.text;
    password = passwordController.text;

    print('Email: $email, Password: $password');

    if (email == '' || password == '') {
      showAlert('You must fill all fields.', context);
    } else if (email == correctEmail && password == correctPassword) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }), (route) => false);
    } else {
      showAlert('Invalid email and password.', context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    email = await prefs.getString('email');
    password = await prefs.getString('password');

    if (email != null && email != '') {
      validateEmailPassword();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  void validateEmailFormat(String) {
    if (!EmailValidator.validate(emailController.text) &&
        emailController.text != '') {
      setState(() {
        shouldShowEmailValidationText = true;
      });
    } else {
      setState(() {
        shouldShowEmailValidationText = false;
      });
    }
  }
}
