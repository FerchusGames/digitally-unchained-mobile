import 'package:digitally_unchained/home.dart';
import 'package:digitally_unchained/register.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email, password;
  bool isShowingEmailValidationText = false;

  Future<void> validateEmailPassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? correctEmail = await prefs.getString('email');
    String? correctPassword = await prefs.getString('password');

    if(email == '' || password == ''){
      showAlert('You must fill all fields.');
    }
    else if(email == correctEmail && password == correctPassword){

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context){
            return Home();
          }
      ), (route) => false);
    }
    else{
      showAlert('Invalid email and password.');
    }
  }

  void showAlert(message){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Alert'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('Accept'),
              ),
            ],
          );
        }
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> read_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    email = await prefs.getString('email');
    password = await prefs.getString('password');

    if(email != null && email != ''){
      validateEmailPassword();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read_data();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        final FocusScopeNode focus = FocusScope.of(context);
        if(!focus.hasPrimaryFocus && focus.hasFocus){
          FocusManager.instance.primaryFocus?.unfocus();
        }
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
                      child: Image.asset('images/du_logo_dark.png')
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 24),
                    alignment: Alignment.centerLeft,
                    child: Text('Login with your email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: emailController,
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.go,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'rlight',
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      maxLength: 254,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(TEXT_FIELD_BACKGROUND_COLOR),
                        labelText: 'Email address',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        counterText: '',
                        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
                      ),
                      onChanged: (String){
                        if(!EmailValidator.validate(emailController.text) && emailController.text != ''){
                          setState(() { isShowingEmailValidationText = true; });
                        }
                        else{
                          setState(() { isShowingEmailValidationText = false; });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: isShowingEmailValidationText,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Text('Write a valid email address.',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'rlight',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: isShowingEmailValidationText,
                      child: SizedBox(height: 10,)
                  ),
                  SizedBox(height: 10),
                  Container( // Password TextField
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: passwordController,
                      autofocus: false,
                      textInputAction: TextInputAction.go,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'rlight',
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      maxLength: 254,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(TEXT_FIELD_BACKGROUND_COLOR),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        counterText: '',
                        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    width: 1000,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: (){
                        FocusScope.of(context).unfocus();

                        email = emailController.text;
                        password = passwordController.text;

                        print('Email: $email, Password: $password');

                        validateEmailPassword();
                      },
                      child: const Text('CONTINUE',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text("Don't have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'rlight',
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context){
                            return Register();
                          }
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Text('SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'rbold',
                        ),
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
}
