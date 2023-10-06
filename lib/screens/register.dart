import 'package:digitally_unchained/collections/colors.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitally_unchained/collections/validators.dart';
import 'package:digitally_unchained/collections/user_messages.dart';

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
        unfocusWidgets(context);
      },
      child: Scaffold(
        backgroundColor: Color(BACKGROUND_COLOR),
        body: ListView(
          children: [
            SafeArea(
                child: Column(
              children: [
                SizedBox(
                  height: 60,
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
                    style: titleTextStyle,
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
                      textController: emailController, label: 'Email Address'),
                ),
                TextFieldValidationWarning(message: EMAIL_VALIDATION_WARNING_TEXT, shouldShow: shouldShowEmailValidationText),
                SizedBox(
                  height: textFieldVerticalSpace,
                  width: double.infinity,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: textFieldHorizontalPadding),
                  child: DarkTextField(
                      textController: passwordController, label: 'Password'),
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
                      label: 'Confirm Password'),
                ),
                SizedBox(
                  height: textFieldVerticalSpace,
                  width: double.infinity,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  void checkAndSetEmailValidation(email) {
    bool isValid = validateEmailFormat(email);
    setState(() {
      shouldShowEmailValidationText = !isValid;
    });
  }

  Future<void> save_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //await prefs.setString('email', emailController.text);
    //await prefs.setString('password', passwordController.text);
  }
}
