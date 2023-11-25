import 'package:digitally_unchained/collections/pref_keys.dart';
import 'package:digitally_unchained/collections/user_warning.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/validators.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool shouldShowEmailValidationText = false;

  var data;

  @override
  Widget build(BuildContext context) {
    double textFieldVerticalSpace = 32;

    return GestureDetector(
      onTap: () {
        MyFunctions.unfocusWidgets(context);
      },
      child: Scaffold(
        backgroundColor: Color(MyColors.backgroundMain),
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                      margin: EdgeInsets.all(20),
                      height: 160,
                      child: Image.asset('images/du_logo_dark.png')),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 24),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login with your email',
                      style: TextStyles.screenTitle,
                    ),
                  ),
                  DarkTextField(
                    textController: emailController,
                    label: 'Email address',
                    onTextChanged: checkAndSetEmailValidation,
                  ),
                  SizedBox(
                      height: textFieldVerticalSpace / 4 * 1,
                      width: double.infinity),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: TextFieldValidationWarning(
                      shouldShow: shouldShowEmailValidationText,
                      message: UserWarnings.emailValidation,
                    ),
                  ),
                  SizedBox(
                    height: textFieldVerticalSpace / 4 * 3,
                    width: double.infinity,
                  ),
                  DarkTextField(
                    label: 'Password',
                    textController: passwordController,
                    hasObscureText: true,
                  ),
                  SizedBox(height: textFieldVerticalSpace),
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        login(emailController.text,
                            passwordController.text);
                      },
                      child: Text(
                        'CONTINUE',
                        style: TextStyles.buttonText,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: textFieldVerticalSpace * 1.5, width: double.infinity),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Don't have an account?",
                      style: TextStyles.suggestion,
                    ),
                  ),
                  SizedBox(height: 12, width: double.infinity),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SIGN UP',
                        style: TextStyles.textButton,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: textFieldVerticalSpace * 1.5, width: double.infinity),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Forgot Your Password?",
                      style: TextStyles.suggestion,
                    ),
                  ),
                  SizedBox(height: 12, width: double.infinity),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/recover_password');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RECOVER PASSWORD',
                        style: TextStyles.textButton,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> checkPreviousLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? isLoggedIn = await prefs.getBool(PrefKey.isLoggedIn);

    if (isLoggedIn ?? false) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreviousLogin();
  }

  void checkAndSetEmailValidation(email) {
    bool isValid = Validators.validateEmailFormat(email);
    setState(() {
      shouldShowEmailValidationText = !isValid;
    });
  }

  Future<void> login(String email, String password) async {
    var url =
        Uri.parse('https://digitallyunchained.rociochavezml.com/php/login.php');
    var response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      await saveData();
      resetTextControllers();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      MyFunctions.showAlert('Invalid email or password', context);
    }
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefKey.firstName, data['firstName']);
    await prefs.setString(PrefKey.lastName, data['lastName']);
    await prefs.setString(PrefKey.email, data['email']);
    await prefs.setString(PrefKey.password, data['password']);
    await prefs.setString(PrefKey.id, data['id']);
    await prefs.setBool(PrefKey.isLoggedIn, true);
  }

  void resetTextControllers() {
    setState(() {
      emailController.text = '';
      passwordController.text = '';
    });
  }
}
