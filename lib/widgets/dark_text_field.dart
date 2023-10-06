import 'package:flutter/material.dart';
import '../collections/colors.dart';

class DarkTextField extends StatelessWidget {
  const DarkTextField({
    super.key,
    required this.textController,
    required this.label,
    this.onTextChanged = _defaultOnTextChanged,
    this.hasAutocorrect = false,
    this.textInputActionType = TextInputAction.go,
    this.textCapitalizationType = TextCapitalization.none,
    this.hasObscureText = false,
  });

  static void _defaultOnTextChanged(String value) {}
  
  final Function(String) onTextChanged;
  final TextEditingController textController;
  final String? label;
  final hasAutocorrect;
  final textInputActionType;
  final textCapitalizationType;
  final hasObscureText;

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: textController,
      autofocus: false,
      textInputAction: textInputActionType,
      autocorrect: hasAutocorrect,
      textCapitalization: textCapitalizationType,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'rlight',
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      maxLength: 254,
      obscureText: hasObscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(TEXT_FIELD_BACKGROUND_COLOR),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        counterText: '',
        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
      ),
      onChanged: onTextChanged,
    );
  }
}
