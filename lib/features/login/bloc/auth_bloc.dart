import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/validators/email_validator.dart';
import '../../../core/validators/password_validator.dart';
import '../../../core/validators/username_validator.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'types.dart';

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
  final authDataSource = const AuthRemoteDataSource();
  void _onSignTypeChanged(SignTypeChanged event, Emitter<LoginPageState> emit) {
    final String newButtonText;
    final List<LabelType> newLabelTypes;
    if (event.signType == SignType.signIn) {
      newButtonText = 'Continue';
      newLabelTypes = LoginPageState.getLabelTypes(
        SignType.signIn,
        state.requiredPassword,
      );
    } else {
      newButtonText = 'Sign Up';
      newLabelTypes = LoginPageState.getLabelTypes(
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
      final String newPassError = PasswordValidator.passCreateErrorText(
        state.pass,
        state.minPasswordLen,
      );
      if (newPassError != '') {
        emit(
          state.copyWith(showPassError: true, errorPasswordText: newPassError),
        );
      } else {
        emit(state.copyWith(isLoading: true));
        authDataSource.mockSignIn(state.mail, state.pass).then((errText) {
          if (errText.isNotEmpty) {
            add(PasswordValidationFailed(errText));
          } else {
            add(PasswordValidationSucceeded());
          }
        });
      }
    } else {
      final String newMailError = EmailValidator.mailCreateErrorText(
        state.mail,
      );
      final String newPassError = PasswordValidator.passCreateErrorText(
        state.pass,
        state.minPasswordLen,
      );
      final String newUserError = UsernameValidator.userCreateErrorText(
        state.user,
        state.minUsernameLen,
        state.maxUsernameLen,
      );
      if (state.signType == SignType.signUp &&
          newMailError == '' &&
          newPassError == '' &&
          newUserError == '') {
        emit(state.copyWith(isLoading: true));
        authDataSource.mockSignUp(state.user, state.mail, state.pass).then((
          errText,
        ) {
          if (errText.isNotEmpty) {
            add(
              DataValidationFailed(
                mailError: errText[0],
                passError: errText[1],
                userError: errText[2],
              ),
            );
          } else {
            add(DataValidationSucceeded());
          }
        });
      } else if (state.signType == SignType.signIn && newMailError == '') {
        emit(state.copyWith(isLoading: true, pass: ''));
        authDataSource.mockCheckEmail(state.mail).then((errText) {
          if (errText.isNotEmpty) {
            add(MailValidationFailed(errText));
          } else {
            add(PasswordRequired());
          }
        });
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
    final CheckType newType = EmailValidator.mailCreateCheckType(event.text);
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

  void _onMailValidationFailed(
    MailValidationFailed event,
    Emitter<LoginPageState> emit,
  ) {
    emit(
      state.copyWith(
        isLoading: false,
        showMailError: true,
        errorEmailText: event.errorMessage,
      ),
    );
  }

  void _onDataValidationFailed(
    DataValidationFailed event,
    Emitter<LoginPageState> emit,
  ) {
    emit(
      state.copyWith(
        isLoading: false,
        showMailError: true,
        showPassError: true,
        showUserError: true,
        errorEmailText: event.mailError,
        errorPasswordText: event.passError,
        errorUsernameText: event.userError,
      ),
    );
  }

  void _onPasswordRequired(
    PasswordRequired event,
    Emitter<LoginPageState> emit,
  ) {
    emit(
      state.copyWith(
        isLoading: false,
        requiredPassword: true,
        labelTypes: LoginPageState.getLabelTypes(state.signType, true),
        showPassError: false,
        buttonText: 'Sign In',
      ),
    );
  }

  void _onDataValidationSucceeded(
    DataValidationSucceeded event,
    Emitter<LoginPageState> emit,
  ) {
    emit(state.copyWith(success: true));
  }

  void _onPasswordValidationFailed(
    PasswordValidationFailed event,
    Emitter<LoginPageState> emit,
  ) {
    emit(
      state.copyWith(
        isLoading: false,
        showPassError: true,
        errorPasswordText: event.passError,
      ),
    );
  }

  void _onPasswordValidationSucceeded(
    PasswordValidationSucceeded event,
    Emitter<LoginPageState> emit,
  ) {
    emit(state.copyWith(success: true));
  }
}
