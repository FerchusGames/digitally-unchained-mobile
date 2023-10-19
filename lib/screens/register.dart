import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:digitally_unchained/collections/screens.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitally_unchained/collections/validators.dart';
import 'package:digitally_unchained/collections/user_warning.dart';
import 'package:digitally_unchained/collections/pref_keys.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String passwordConfirmation = '';

  double textFieldVerticalSpace = 32;
  double textFieldHorizontalPadding = 24;

  bool shouldShowEmailValidationText = false;

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(MyColors.darkIconBackground),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: textFieldHorizontalPadding),
                    child: Text(
                      'Create your account',
                      style: TextStyles.screenTitle,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: textFieldHorizontalPadding),
                    child: DarkTextField(
                        textController: firstNameController,
                        label: 'First Name'),
                  ),
                  SizedBox(
                    height: textFieldVerticalSpace,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: textFieldHorizontalPadding),
                    child: DarkTextField(
                        textController: lastNameController, label: 'Last Name'),
                  ),
                  SizedBox(
                    height: textFieldVerticalSpace,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: textFieldHorizontalPadding),
                    child: DarkTextField(
                        onTextChanged: checkAndSetEmailValidation,
                        textController: emailController,
                        label: 'Email Address'),
                  ),
                  SizedBox(
                      height: textFieldVerticalSpace / 4 * 1,
                      width: double.infinity),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: textFieldHorizontalPadding),
                      child: TextFieldValidationWarning(
                          message: UserWarnings.emailValidation,
                          shouldShow: shouldShowEmailValidationText)),
                  SizedBox(
                    height: textFieldVerticalSpace / 4 * 3,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: textFieldHorizontalPadding),
                    child: DarkTextField(
                      textController: passwordController,
                      label: 'Password',
                      hasObscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: textFieldVerticalSpace,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: textFieldHorizontalPadding),
                    child: DarkTextField(
                        textController: passwordConfirmationController,
                        label: 'Confirm Password',
                        hasObscureText: true),
                  ),
                  SizedBox(
                    height: textFieldVerticalSpace,
                    width: double.infinity,
                  ),
                  Container(
                    width: 1000,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setTextVariables();
                        sendData();
                      },
                      child: Text(
                        'SIGN UP',
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
                      "Already have an account?",
                      style: TextStyles.suggestion,
                    ),
                  ),
                  SizedBox(height: 12, width: double.infinity),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'LOG IN',
                        style: TextStyles.textButton,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void setTextVariables() {
    firstName = firstNameController.text.trim();
    lastName = lastNameController.text.trim();
    email = emailController.text.trim();
    password = passwordController.text.trim();
    passwordConfirmation = passwordConfirmationController.text.trim();
  }

  Future<void> validateFields() async {
    List<String> fields = [
      firstName,
      lastName,
      email,
      password,
      passwordConfirmation
    ];

    if (fields.any((field) => field.isEmpty)) {
      MyFunctions.showAlert(UserWarnings.emptyField, context);
    } else if (!Validators.validateEmailFormat(email)) {
      MyFunctions.showAlert(UserWarnings.emailValidation, context);
    } else if (password != passwordConfirmation) {
      MyFunctions.showAlert(UserWarnings.passwordConfirmation, context);
    } else {
      saveData();
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> sendData() async {
    var url = Uri.parse('https://digitallyunchained.rociochavezml.com/php/register.php');
    var response = await http.post(url, body: {
      'firstName' : firstName,
      'lastName' : lastName,
      'email' : email,
      'password' : password,
    }).timeout(Duration(seconds: 90));

    print(response.body);

    var data = jsonDecode(response.body);

    if(response.body != '0')
    {
      resetTextControllers();
      Navigator.pushReplacementNamed(context, '/home');
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
        return Home.withData(data['firstName'], data['lastName'], data['email']);
      }));
    }
    
    else
    {
      MyFunctions.showAlert("There was an error, please report to the administrator", context);
    }
  }

  void resetTextControllers() {
    setState(() {
      firstNameController.text = '';
      lastNameController.text = '';
      emailController.text = '';
      passwordController.text = '';
      passwordConfirmationController.text = '';
    });
  }

  void checkAndSetEmailValidation(email) {
    bool isValid = Validators.validateEmailFormat(email);
    setState(() {
      shouldShowEmailValidationText = !isValid;
    });
  }

  bool passwordMatchesConfirmation() {
    return passwordController.text == passwordConfirmationController.text;
  }

  Future<void> clearPreviousData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefKey.firstName, firstNameController.text.trim());
    await prefs.setString(PrefKey.lastName, lastNameController.text.trim());
    await prefs.setString(PrefKey.email, emailController.text.trim());
    await prefs.setString(PrefKey.password, passwordController.text.trim());
    await prefs.setBool(PrefKey.isLoggedIn, true);
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefKey.firstName, firstNameController.text.trim());
    await prefs.setString(PrefKey.lastName, lastNameController.text.trim());
    await prefs.setString(PrefKey.email, emailController.text.trim());
    await prefs.setString(PrefKey.password, passwordController.text.trim());
    await prefs.setBool(PrefKey.isLoggedIn, true);
  }
}
