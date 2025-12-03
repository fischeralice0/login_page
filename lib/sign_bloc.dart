import 'package:flutter_bloc/flutter_bloc.dart';

enum SignType { signIn, signUp }

enum CheckType { none, cross, check }

enum LabelType { user, mail, pass }

class LoginPageState {
  LoginPageState({
    this.signType = SignType.signIn,
    List<LabelType>? labelTypes,
    this.buttonText = 'Continue',
    this.isLoading = false,
    this.obscurePass = true,
    this.requiredPassword = false,

    this.user = '',
    this.mail = '',
    this.pass = '',

    this.errorUsernameText = '',
    this.errorEmailText = '',
    this.errorPasswordText = '',
    this.mailCheckType = CheckType.none,
    this.showUserError = false,
    this.showMailError = false,
    this.showPassError = false,
    this.minPasswordLen = 8,
    this.minUsernameLen = 3,
    this.maxUsernameLen = 20,

    this.success = false,
  }) : labelTypes =
      labelTypes ?? _getLabelTypes(SignType.signIn, requiredPassword);
  SignType signType;
  List<LabelType> labelTypes;
  String buttonText;
  bool isLoading;
  bool obscurePass;
  bool requiredPassword;

  String user;
  String mail;
  String pass;

  String errorUsernameText;
  String errorEmailText;
  String errorPasswordText;
  bool showUserError;
  bool showMailError;
  bool showPassError;
  CheckType mailCheckType;
  int minPasswordLen;
  int minUsernameLen;
  int maxUsernameLen;

  bool success;

  LoginPageState copyWith({
    SignType? signType,
    List<LabelType>? labelTypes,
    String? buttonText,
    bool? isLoading,
    bool? obscurePass,
    bool? requiredPassword,
    String? user,
    String? mail,
    String? pass,
    String? errorUsernameText,
    String? errorEmailText,
    String? errorPasswordText,
    bool? showUserError,
    bool? showMailError,
    bool? showPassError,
    CheckType? mailCheckType,
    int? minPasswordLen,
    int? minUsernameLen,
    int? maxUsernameLen,
    bool? success,
  }) {
    return LoginPageState(
      signType: signType ?? this.signType,
      labelTypes: labelTypes ?? this.labelTypes,
      buttonText: buttonText ?? this.buttonText,
      isLoading: isLoading ?? this.isLoading,
      obscurePass: obscurePass ?? this.obscurePass,
      requiredPassword: requiredPassword ?? this.requiredPassword,
      user: user ?? this.user,
      mail: mail ?? this.mail,
      pass: pass ?? this.pass,
      errorUsernameText: errorUsernameText ?? this.errorUsernameText,
      errorEmailText: errorEmailText ?? this.errorEmailText,
      errorPasswordText: errorPasswordText ?? this.errorPasswordText,
      showUserError: showUserError ?? this.showUserError,
      showMailError: showMailError ?? this.showMailError,
      showPassError: showPassError ?? this.showPassError,
      mailCheckType: mailCheckType ?? this.mailCheckType,
      minPasswordLen: minPasswordLen ?? this.minPasswordLen,
      minUsernameLen: minUsernameLen ?? this.minUsernameLen,
      maxUsernameLen: maxUsernameLen ?? this.maxUsernameLen,
      success: success ?? this.success,
    );
  }

  static List<LabelType> _getLabelTypes(
      SignType signType,
      bool requiredPassword,
      ) {
    if (signType == SignType.signIn && requiredPassword) {
      return [LabelType.pass];
    } else if (signType == SignType.signIn) {
      return [LabelType.mail];
    } else {
      return [LabelType.user, LabelType.mail, LabelType.pass];
    }
  }
}

class SignBloc extends Bloc<LoginPageEvent, LoginPageState> {
  SignBloc() : super(LoginPageState()) {
    on<SignTypeChanged>(_onSignTypeChanged);
    on<ButtonPressed>(_onButtonPressed);
    on<MailChanged>(_onMailChanged);
    on<PassChanged>(_onPassChanged);
    on<UserChanged>(_onUserChanged);
    on<ObscurePass>(_onObscurePass);
    on<MailValidationFailed>(_onMailValidationFailed);
    on<DataValidationFailed>(_onDataValidationFailed);
    on<PasswordRequired>(_onPasswordRequired);
    on<DataValidationSucceeded>(_onDataValidationSucceeded);
    on<PasswordValidationFailed>(_onPasswordValidationFailed);
    on<PasswordValidationSucceeded>(_onPasswordValidationSucceeded);
  }
  void _onSignTypeChanged(SignTypeChanged event, Emitter<LoginPageState> emit) {
    final String newButtonText;
    final List<LabelType> newLabelTypes;
    if (event.signType == SignType.signIn) {
      newButtonText = 'Continue';
      newLabelTypes = LoginPageState._getLabelTypes(
        SignType.signIn,
        state.requiredPassword,
      );
    } else {
      newButtonText = 'Sign Up';
      newLabelTypes = LoginPageState._getLabelTypes(
        SignType.signUp,
        state.requiredPassword,
      );
    }
    emit(
      state.copyWith(
        signType: event.signType,
        buttonText: newButtonText,
        labelTypes: newLabelTypes,
      ),
    );
  }

  void _onButtonPressed(ButtonPressed event, Emitter<LoginPageState> emit) {
    if (state.signType == SignType.signIn && state.requiredPassword) {
      final String newPassError = _passCreateErrorText(state.pass, state.minPasswordLen);
      if (newPassError != '') {
        emit(state.copyWith(showPassError: true, errorPasswordText: newPassError));
      }
      else{
        emit(state.copyWith(isLoading: true));
        checkPassword(state.mail, state.pass);
      }
    }
    else {
      final String newMailError = _mailCreateErrorText(state.mail);
      final String newPassError = _passCreateErrorText(
        state.pass,
        state.minPasswordLen,
      );
      final String newUserError = _userCreateErrorText(
        state.user,
        state.minUsernameLen,
        state.maxUsernameLen,
      );
      if (state.signType == SignType.signUp &&
          newMailError == '' &&
          newPassError == '' &&
          newUserError == '') {
        emit(state.copyWith(isLoading: true));
        checkData(state.user, state.mail, state.pass);
      } else if (state.signType == SignType.signIn && newMailError == '') {
        emit(state.copyWith(isLoading: true, pass: ''));
        checkMailAddress(state.mail);
      } else {
        emit(
          state.copyWith(
            showMailError: true,
            showPassError: true,
            showUserError: true,
            errorEmailText: newMailError,
            errorPasswordText: newPassError,
            errorUsernameText: newUserError,
          ),
        );
      }
    }
  }

  void _onMailChanged(MailChanged event, Emitter<LoginPageState> emit) {
    final CheckType newType = _mailCreateCheckType(event.text);
    emit(
      state.copyWith(
        mail: event.text,
        obscurePass: state.obscurePass,
        mailCheckType: newType,
        showMailError: false,
      ),
    );
    print('mail: ${event.text}');
  }

  void _onPassChanged(PassChanged event, Emitter<LoginPageState> emit) {
    emit(
      state.copyWith(
        pass: event.text,
        obscurePass: state.obscurePass,
        showPassError: false,
      ),
    );
    print('pass: ${event.text}');
  }

  void _onUserChanged(UserChanged event, Emitter<LoginPageState> emit) {
    emit(
      state.copyWith(
        user: event.text,
        obscurePass: state.obscurePass,
        showUserError: false,
      ),
    );
    print('user: ${event.text}');
  }

  void _onObscurePass(ObscurePass event, Emitter<LoginPageState> emit) {
    emit(state.copyWith(obscurePass: !state.obscurePass));
  }

  String _userCreateErrorText(String user, int min, int max) {
    if (user.isEmpty) return 'This field is required';
    if (user.length < min) return 'The username is too short';
    if (user.length > max) return 'The username is too long';
    return '';
  }

  String _mailCreateErrorText(String mail) {
    if (mail.isEmpty) return 'This field is required';
    if (mail.length > 254) return 'This text is too long';
    final parts = mail.split('@');
    if (parts.length > 2) return 'Too much @';
    if (parts.length < 2) return '@ required';
    if (parts[0].isEmpty) return 'Username required';
    if (parts[0].length > 64) return 'Username is too long';
    if (parts[1].isEmpty) return 'Domain required';
    if (parts[1].length > 253) return 'Domain is too long';
    if (parts[1].contains('..')) return 'You cannot use two periods in a row';
    if (parts[1].startsWith('.')) return 'You cannot use a period after @';
    if (parts[1].endsWith('.')) return 'An email address cannot end with a period';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (emailRegex.hasMatch(mail)) {
      return '';
    } else {
      return 'Email address format error';
    }
  }

  CheckType _mailCreateCheckType(String mail) {
    if (mail.isEmpty) return CheckType.none;
    if (mail.length > 254) return CheckType.cross;
    final parts = mail.split('@');
    if (parts.length > 2) return CheckType.cross;
    if (parts.length < 2) return CheckType.cross;
    if (parts[0].isEmpty) return CheckType.cross;
    if (parts[0].length > 64) return CheckType.cross;
    if (parts[1].isEmpty) return CheckType.cross;
    if (parts[1].length > 253) return CheckType.cross;
    if (parts[1].contains('..')) return CheckType.cross;
    if (parts[1].startsWith('.')) return CheckType.cross;
    if (parts[1].endsWith('.')) return CheckType.cross;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (emailRegex.hasMatch(mail)) {
      return CheckType.check;
    } else {
      return CheckType.cross;
    }
  }

  String _passCreateErrorText(String pass, int min) {
    if (pass.isEmpty) return 'This field is required';
    if (pass.length < min) return 'The password is too short';
    // Weak password ??
    return '';
  }

  Future<void> checkMailAddress(String mail) async {
    //there will be a request to the server
    await Future<void>.delayed(const Duration(seconds: 2));
    const bool result = true; //This is a constant for testing
    if (!result) {
      add(MailValidationFailed('This email is not registered'));
    } else {
      add(PasswordRequired());
    }
  }

  Future<void> checkPassword(String mail, String pass) async {
    //there will be a request to the server
    await Future<void>.delayed(const Duration(seconds: 2));
    const bool result = true; //This is a constant for testing
    if (!result) {
      add(PasswordValidationFailed('Incorrect password'));
    } else {
      add(PasswordValidationSucceeded());
    }
  }

  Future<void> checkData(String user, String mail, String pass) async {
    //there will be a request to the server
    await Future<void>.delayed(const Duration(seconds: 2));
    const bool result = true; //This is a constant for testing
    if (!result) {
      add(
        DataValidationFailed(
          mailError: 'This email already used',
          passError: 'Weak password',
          userError: 'This username already used',
        ),
      );
    }
    else {
      add(DataValidationSucceeded());
    }
  }
  void _onMailValidationFailed(MailValidationFailed event, Emitter<LoginPageState> emit) {
    emit(state.copyWith(
      isLoading: false,
      showMailError: true,
      errorEmailText: event.errorMessage,
    ));
  }

  void _onDataValidationFailed(DataValidationFailed event, Emitter<LoginPageState> emit) {
    emit(state.copyWith(
      isLoading: false,
      showMailError: true,
      showPassError: true,
      showUserError: true,
      errorEmailText: event.mailError,
      errorPasswordText: event.passError,
      errorUsernameText: event.userError,
    ));
  }

  void _onPasswordRequired(PasswordRequired event, Emitter<LoginPageState> emit) {
    emit(state.copyWith(
      isLoading: false,
      requiredPassword: true,
      labelTypes: LoginPageState._getLabelTypes(state.signType, true),
      showPassError: false,
      buttonText: 'Sign In',
    ));
  }

  void _onDataValidationSucceeded(DataValidationSucceeded event, Emitter<LoginPageState> emit) {
    emit(state.copyWith(success: true));
  }

  void _onPasswordValidationFailed(PasswordValidationFailed event, Emitter<LoginPageState> emit) {
    emit(state.copyWith(
      isLoading: false,
      showPassError: true,
      errorPasswordText: event.passError,
    ));
  }

  void _onPasswordValidationSucceeded(PasswordValidationSucceeded event, Emitter<LoginPageState> emit) {
    emit(state.copyWith(success: true));
  }
}

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