import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/validators.dart';
import 'package:digitally_unchained/collections/user_warning.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {

  final emailController = TextEditingController();

  bool shouldShowEmailValidationText = false;

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
                      'Recover your password',
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
                  SizedBox(height: textFieldVerticalSpace),
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        submit();
                      },
                      child: Text(
                        'SUBMIT',
                        style: TextStyles.buttonText,
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

  void submit() {
    if(emailController.text != '' && !shouldShowEmailValidationText)
      {
        MyFunctions.showMessage("We've sent a link to your email address to recover your password.", context);
      }
    else
      {
        MyFunctions.showAlert("Please use a valid email address.", context);
      }

  }

  void checkAndSetEmailValidation(email) {
    bool isValid = Validators.validateEmailFormat(email);
    setState(() {
      shouldShowEmailValidationText = !isValid;
    });
  }
}

