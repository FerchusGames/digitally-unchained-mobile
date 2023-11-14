import 'package:digitally_unchained/collections/pref_keys.dart';
import 'package:digitally_unchained/collections/screens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyFunctions {
  static void showAlert(message, context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Accept'),
              ),
            ],
          );
        });
  }

  static void unfocusWidgets(context) {
    final FocusScopeNode focus = FocusScope.of(context);
    if (!focus.hasPrimaryFocus && focus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefKey.isLoggedIn, false);
    await prefs.setString(PrefKey.firstName, "");
    await prefs.setString(PrefKey.lastName, "");
    await prefs.setString(PrefKey.email, "");
    await prefs.setString(PrefKey.password, "");
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  static Future<String> getProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('https://digitallyunchained.rociochavezml.com/php/show_profile_picture.php');
    var response = await http.post(url, body: {
      'id' : await prefs.getString(PrefKey.id),
    }).timeout(Duration(seconds: 90));

    return response.body;
  }
}
