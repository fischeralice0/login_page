import 'types.dart';

abstract class LoginPageEvent {}

class SignTypeChanged extends LoginPageEvent {
  SignTypeChanged(this.signType);
  final SignType signType;
}

class ButtonPressed extends LoginPageEvent {
  ButtonPressed(this.signType);
  final SignType signType;
}

class MailChanged extends LoginPageEvent {
  MailChanged(this.text);
  final String text;
}

class PassChanged extends LoginPageEvent {
  PassChanged(this.text);
  final String text;
}

class UserChanged extends LoginPageEvent {
  UserChanged(this.text);
  final String text;
}

class ObscurePass extends LoginPageEvent {
  ObscurePass();
}

class MailValidationFailed extends LoginPageEvent {
  MailValidationFailed(this.errorMessage);
  final String errorMessage;
}

class DataValidationFailed extends LoginPageEvent {
  DataValidationFailed({
    required this.mailError,
    required this.passError,
    required this.userError,
  });
  final String mailError;
  final String passError;
  final String userError;
}

class DataValidationSucceeded extends LoginPageEvent {
  DataValidationSucceeded();
}

class PasswordRequired extends LoginPageEvent {}

class PasswordValidationFailed extends LoginPageEvent {
  PasswordValidationFailed(this.passError);
  final String passError;
}

class PasswordValidationSucceeded extends LoginPageEvent {}
