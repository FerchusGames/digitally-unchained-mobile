import 'package:digitally_unchained/collections/colors.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitally_unchained/collections/validators.dart';
import 'package:digitally_unchained/collections/user_warning.dart';
import 'package:digitally_unchained/collections/pref_keys.dart';
import 'package:digitally_unchained/screens/home.dart';

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
        backgroundColor: Color(BACKGROUND_MAIN_COLOR),
        body: ListView(
          children: [
            SafeArea(
                child: Column(
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
                      color: DARK_ICON_BACKGROUND_COLOR,
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
                      textController: firstNameController, label: 'First Name'),
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
                      validateFields();
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
            ))
          ],
        ),
      ),
    );
  }

  Future<void> validateFields() async {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String passwordConfirmation = passwordConfirmationController.text.trim();

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
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    }
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

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefKey.firstName, firstNameController.text);
    await prefs.setString(PrefKey.lastName, lastNameController.text);
    await prefs.setString(PrefKey.email, emailController.text);
    await prefs.setString(PrefKey.password, passwordController.text);
    await prefs.setBool(PrefKey.isLoggedIn, true);
  }
}
