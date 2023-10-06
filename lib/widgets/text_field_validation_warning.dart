import 'package:flutter/material.dart';

class TextFieldValidationWarning extends StatelessWidget {
  const TextFieldValidationWarning({
    super.key,
    required this.shouldShow,
    required this.message,
  });

  final shouldShow;
  final message;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Visibility(
          visible: shouldShow,
          child: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'rlight',
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 10,
                width: double.infinity,
              ),
            ],
          ))
    ]);
  }
}
