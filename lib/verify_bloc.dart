import 'package:flutter_bloc/flutter_bloc.dart';

enum VerifyType {
  mail,
  password,
  username,
  notEmpty,
  none,
}

class VerifyBloc extends Bloc<LabelValidationEvent, LabelValidationState>{

  VerifyBloc({
    required this.verifyType,
    this.minPassLen = 8,
    this.minUserLen = 3,
    this.maxUserLen = 20,
  }) : super(Verify()) {
    on<LabelValueChange>(_onValueChange);
  }

  final VerifyType verifyType;
  final int minPassLen;
  final int minUserLen;
  final int maxUserLen;

  void _onValueChange(LabelValueChange event, Emitter<LabelValidationState> emit) {
    if (event.value.isEmpty) {
      emit(Verify());
      return;
    }

    bool isValid = false;

    switch (verifyType) {
      case VerifyType.mail:
        isValid = _isMail(event.value);
        break;

      case VerifyType.password:
        isValid = _isPass(event.value);
        break;

      case VerifyType.username:
        isValid = _isUsername(event.value);
        break;

      case VerifyType.notEmpty:
        isValid = event.value.isNotEmpty;
        break;

      case VerifyType.none:
        isValid = true;
        break;
    }
    if (isValid) {
      emit(LabelValid());
    } else {
      emit(LabelInvalid());
    }
  }
  bool _isMail(String mail) {
    if (mail.isEmpty) return false;
    if (mail.length > 254) return false;
    final parts = mail.split('@');
    if (parts.length != 2) return false;
    if (parts[0].isEmpty || parts[0].length > 64) return false;
    if (parts[1].isEmpty || parts[1].length > 253) return false;
    if (parts[1].contains('..')) return false;
    if (parts[1].startsWith('.') || parts[1].endsWith('.')) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(mail);
  }

  bool _isPass(String pass) {
    return pass.length >= minPassLen;
  }

  bool _isUsername(String username) {
    return username.length >= minUserLen && username.length <= maxUserLen;
  }
}

abstract class LabelValidationEvent {}

class LabelValueChange extends LabelValidationEvent {
  LabelValueChange(this.value);
  final String value;
}

abstract class LabelValidationState {}

class Verify extends LabelValidationState {}
class LabelValid extends LabelValidationState {}
class LabelInvalid extends LabelValidationState {
  LabelInvalid({this.errorMessage});
  final String? errorMessage;
}