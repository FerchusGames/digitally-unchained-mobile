import 'package:email_validator/email_validator.dart';

bool validateEmailFormat(String email) {
  return EmailValidator.validate(email);
}
