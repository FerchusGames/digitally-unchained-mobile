import 'package:email_validator/email_validator.dart';

class Validators {
  static bool validateEmailFormat(String email) {
    return EmailValidator.validate(email.trim()) || email == '';
  }
}
