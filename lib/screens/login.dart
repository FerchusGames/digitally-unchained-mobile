import 'package:digitally_unchained/collections/pref_keys.dart';
import 'package:digitally_unchained/collections/user_warning.dart';
import 'package:digitally_unchained/screens/home.dart';
import 'package:digitally_unchained/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitally_unchained/collections/colors.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/validators.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool shouldShowEmailValidationText = false;

  @override
  Widget build(BuildContext context) {
    double textFieldVerticalSpace = 32;

    return GestureDetector(
      onTap: () {
        MyFunctions.unfocusWidgets(context);
      },
      child: Scaffold(
        backgroundColor: Color(BACKGROUND_MAIN_COLOR),
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
                      style: TextStyles.screenTitle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DarkTextField(
                      textController: emailController,
                      label: 'Email address',
                      onTextChanged: checkAndSetEmailValidation,
                    ),
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
                  Container(
                    // Password TextField
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DarkTextField(
                      label: 'Password',
                      textController: passwordController,
                      hasObscureText: false,
                    ),
                  ),
                  SizedBox(height: textFieldVerticalSpace),
                  Container(
                    width: 1000,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        validateFields();
                      },
                      child: Text(
                        'CONTINUE',
                        style: TextStyles.buttonText,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: textFieldVerticalSpace, width: double.infinity),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> validateFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? correctEmail = await prefs.getString('email');
    String? correctPassword = await prefs.getString('password');

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == '' || password == '') {
      MyFunctions.showAlert(UserWarnings.emptyField, context);
    } else if (email == correctEmail && password == correctPassword) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    } else {
      MyFunctions.showAlert(UserWarnings.invalidPasswordEmail, context);
    }
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
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
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
}
