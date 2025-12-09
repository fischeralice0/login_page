import 'types.dart';

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
           labelTypes ?? getLabelTypes(SignType.signIn, requiredPassword);
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

  static List<LabelType> getLabelTypes(
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
