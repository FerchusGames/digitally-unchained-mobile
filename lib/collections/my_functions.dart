import 'package:flutter/material.dart';

void showAlert(message, context) {
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

void unfocusWidgets(context){
  final FocusScopeNode focus = FocusScope.of(context);
  if (!focus.hasPrimaryFocus && focus.hasFocus) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}