import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SignType{signIn, signUp}
enum LabelType{user, mail, pass}

class MailLabelSettings{
  MailLabelSettings({
    required this.leftIcon,
    required this.labelName,
    required this.hideText,
    required this.showCheck,
    this.errorMessage,
    required this.labelType,
  });

  final IconData leftIcon;
  final String labelName;
  final bool hideText;
  final bool showCheck;
  final String? errorMessage;
  final LabelType labelType;
}

class LoginPageState{
  LoginPageState({
    this.signType = SignType.signIn,
    List<MailLabelSettings>? labels,
    this.isProgress = false,
    this.username = '',
    this.email = '',
    this.password = '',
    this.errorUsernameText = '',
    this.errorEmailText = '',
    this.errorPasswordText = '',
    this.minPasswordLen = 8,
    this.minUsernameLen = 3,
    this.maxUsernameLen = 20,
    this.buttonText = 'Continue',
  }): labels = labels ?? _getLabels(SignType.signIn,minUsernameLen,maxUsernameLen, minPasswordLen);

  SignType signType;
  List<MailLabelSettings> labels;
  bool isProgress;
  String username;
  String email;
  String password;
  String errorUsernameText;
  String errorEmailText;
  String errorPasswordText;
  int minPasswordLen;
  int minUsernameLen;
  int maxUsernameLen;
  String buttonText;



  LoginPageState copyWith({
    SignType? signType,
    List<MailLabelSettings>? labels,
    bool? isProgress,
    String? username,
    String? email,
    String? password,
    String? errorUsernameText,
    String? errorEmailText,
    String? errorPasswordText,
    int? minPasswordLen,
    int? minUsernameLen,
    int? maxUsernameLen,

  }) {
    return LoginPageState(
      signType: signType ?? this.signType,
      labels: labels ?? this.labels,
      isProgress: isProgress ?? this.isProgress,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      errorUsernameText: errorUsernameText ?? this.errorUsernameText,
      errorEmailText: errorEmailText ?? this.errorEmailText,
      errorPasswordText: errorPasswordText ?? this.errorPasswordText,
      minPasswordLen: minPasswordLen ?? this.minPasswordLen,
      minUsernameLen: minUsernameLen ?? this.minUsernameLen,
      maxUsernameLen: maxUsernameLen ?? this.maxUsernameLen,
    );
  }

  static List<MailLabelSettings> _getLabels(
      SignType signType,
      int minUsernameLen,
      int maxUsernameLen,
      int minPasswordLen){
    if (signType == SignType.signIn) {
      return [
        MailLabelSettings(
          labelName: 'Email Address',
          leftIcon: Icons.mail_outline_rounded,
          hideText: false,
          showCheck: true,
          labelType: LabelType.mail,
        ),
      ];
    }
    else{
      return [
        MailLabelSettings(
          labelName: 'Username',
          leftIcon: Icons.person,
          hideText: false,
          showCheck: false,
          labelType: LabelType.user,
        ),
        MailLabelSettings(
          labelName: 'Email Address',
          leftIcon: Icons.mail_outline_rounded,
          hideText: false,
          showCheck: true,
          labelType: LabelType.mail,
        ),
        MailLabelSettings(
          labelName: 'Password',
          leftIcon: Icons.lock_rounded,
          hideText: true,
          showCheck: false,
          labelType: LabelType.pass,
        ),
      ];
    }
  }

}

class SignBloc extends Bloc<LoginPageEvent, LoginPageState> {
  SignBloc() : super(LoginPageState()) {
    on<SignTypeChanged>(_onSignTypeChanged);
    on<LabelTextChanged>(_onLabelTextChanged);
  }
  void _onSignTypeChanged(SignTypeChanged event, Emitter<LoginPageState> emit) {
    final newLabels = LoginPageState._getLabels(event.signType, state.minUsernameLen, state.maxUsernameLen, state.minPasswordLen);
    emit(state.copyWith(
      signType: event.signType,
      labels: newLabels,
      errorUsernameText: '',
      errorEmailText: '',
      errorPasswordText: '',
    ));
  }

  void _onLabelTextChanged(LabelTextChanged event, Emitter<LoginPageState> emit) {
    switch (event.labelType) {
      case LabelType.user:
        emit(state.copyWith(username: event.text, errorUsernameText: _userCreateErrorText(event.text, state.minUsernameLen, state.maxUsernameLen)));
        break;
      case LabelType.mail:
        emit(state.copyWith(email: event.text, errorEmailText: _mailCreateErrorText(event.text)));
        break;
      case LabelType.pass:
        emit(state.copyWith(password: event.text, errorPasswordText: _passCreateErrorText(event.text, state.minPasswordLen)));
        break;
    }
  }
  String _userCreateErrorText(String user, int min, int max) {
    if (user.isEmpty) return '';
    if (user.length < min) return 'The username is too short';
    if (user.length > max) return 'The username is too long';
    return '';
  }
  String _mailCreateErrorText(String mail) {
    if (mail.isEmpty) return '';
    if (mail.length > 254) return 'This text is too long';
    final parts = mail.split('@');
    if (parts.length != 2) return 'Too much @';
    if (parts[0].isEmpty) return 'Username required';
    if (parts[0].length > 64) return 'Username is too long';
    if (parts[1].isEmpty ) return 'Domain required';
    if (parts[1].length > 253) return 'Domain is too long';
    if (parts[1].contains('..')) return 'You cannot use two periods in a row';
    if (parts[1].startsWith('.') ) return 'You cannot use a period after @';
    if (parts[1].endsWith('.')) return 'An email address cannot end with a period';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (emailRegex.hasMatch(mail)) {
      return '';
    }
    else{
      return 'Email address format error';
    }
  }
  String _passCreateErrorText(String pass, int min) {
    if (pass.isEmpty) return '';
    if (pass.length < min) return 'The password is too short';
    return '';
  }
}

abstract class LoginPageEvent {}

class SignTypeChanged extends LoginPageEvent {
  SignTypeChanged(this.signType);
  final SignType signType;
}

class LabelTextChanged extends LoginPageEvent {
  LabelTextChanged(this.labelType, this.text);
  final LabelType labelType;
  final String text;
}