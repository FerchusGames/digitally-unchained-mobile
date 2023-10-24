import 'package:flutter/material.dart';
import '../collections/my_colors.dart';

class DarkTextField extends StatelessWidget {
  const DarkTextField({
    super.key,
    required this.textController,
    this.label,
    this.inputType = TextInputType.text,
    this.horizontalPadding = 30,
    this.verticalPadding = 10,
    this.onTextChanged = _defaultOnTextChanged,
    this.hasAutocorrect = false,
    this.textInputActionType = TextInputAction.go,
    this.textCapitalizationType = TextCapitalization.none,
    this.hasObscureText = false,
    this.isEnabled = true,
  });

  static void _defaultOnTextChanged(String value) {}

  final Function(String) onTextChanged;
  final TextEditingController textController;
  final String? label;
  final TextInputType inputType;
  final double horizontalPadding;
  final double verticalPadding;
  final hasAutocorrect;
  final textInputActionType;
  final textCapitalizationType;
  final hasObscureText;
  final isEnabled;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: TextField(
        controller: textController,
        keyboardType: inputType,
        enabled: isEnabled,
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
          fillColor: Color(MyColors.textFieldBackground),
          labelText: label,
          labelStyle: isEnabled
              ? TextStyle(color: Colors.grey[400])
              : TextStyle(color: Colors.grey[700]),
          counterText: '',
          contentPadding:
              EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
        ),
        onChanged: onTextChanged,
      ),
    );
  }
}
