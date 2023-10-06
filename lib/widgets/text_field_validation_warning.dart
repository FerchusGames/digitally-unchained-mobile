import 'package:flutter/material.dart';

class TextFieldValidationWarning extends StatelessWidget {
  const TextFieldValidationWarning({
    super.key,
    required this.shouldShow,
  });

  final shouldShow;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Visibility(
        visible: shouldShow,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            'Write a valid email address.',
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'rlight',
              fontSize: 12,
            ),
          ),
        ),
      ),
      Visibility(
          visible: shouldShow,
          child: SizedBox(
            height: 10,
            width: double.infinity,
          ))
    ]);
  }
}
