import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'colors_and_images.dart';
import 'sign_bloc.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Login Page', home: MyLoginPage());
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  late SignBloc _signBloc;
  late TextEditingController _userController;
  late TextEditingController _mailController;
  late TextEditingController _passController;

  @override
  void initState() {
    super.initState();
    _signBloc = SignBloc();
    _userController = TextEditingController();
    _mailController = TextEditingController();
    _passController = TextEditingController();
  }

  @override
  void dispose() {
    _userController.dispose();
    _mailController.dispose();
    _passController.dispose();
    _signBloc.close();
    super.dispose();
  }

  void _syncControllersWithState(LoginPageState state) {
    if (_mailController.text != state.mail) {
      _mailController.text = state.mail;
    }
    if (_userController.text != state.user) {
      _userController.text = state.user;
    }
    if (_passController.text != state.pass) {
      _passController.text = state.pass;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignBloc, LoginPageState>(
      bloc: _signBloc,
      builder: (context, state) {
        _syncControllersWithState(state);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                createLogo(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: state.success == false
                          ? [
                              createTexts(),
                              const SizedBox(height: 20),
                              createSignInSignUpButton(state, context),
                              const SizedBox(height: 20),
                              createLabels(state),
                              createBlueButtonOrLoad(state),
                              const SizedBox(height: 20),
                              createOrLine(),
                              const SizedBox(height: 20),
                              createOrButtons(),
                            ]
                          : [createSuccess()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget createLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(AppImages.logo, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          const Text(
            'Projyn',
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontFamily: 'RubikSB',
            ),
          ),
        ],
      ),
    );
  }

  Widget createTexts() {
    return const Column(
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontFamily: 'RubikB',
          ),
        ),
        Text(
          'Please enter Your details',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.dustyGray,
            fontFamily: 'RubikR',
          ),
        ),
      ],
    );
  }

  Widget createSignInSignUpButton(LoginPageState state, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w;
        if (constraints.maxWidth > 600) {
          w = 600;
        } else {
          w = constraints.maxWidth;
        }
        final double buttonWidth = (w - 69) / 2;
        return Container(
          padding: const EdgeInsets.only(left: 3, top: 3, bottom: 3, right: 3),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: AppColors.athensGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 534),
            child: Row(
              children: [
                partOfSignButton(state, buttonWidth, true),
                const SizedBox(width: 3),
                partOfSignButton(state, buttonWidth, false),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget partOfSignButton(
    LoginPageState state,
    double buttonWidth,
    bool isSignIn,
  ) {
    return GestureDetector(
      onTap: () {
        if (state.isLoading == false) {
          if (state.signType == SignType.signIn && !isSignIn) {
            _signBloc.add(SignTypeChanged(SignType.signUp));
          }
          if (state.signType == SignType.signUp && isSignIn) {
            _signBloc.add(SignTypeChanged(SignType.signIn));
          }
        }
      },
      child: SizedBox(
        width: buttonWidth,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color:
                (state.signType == SignType.signIn && isSignIn) ||
                    (state.signType == SignType.signUp && !isSignIn)
                ? Colors.white
                : AppColors.athensGray,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Center(
            child: Text(
              isSignIn ? 'Sign In' : 'Sign Up',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: 'RubikR',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createLabels(LoginPageState state) {
    return Column(
      children: state.labelTypes.map((labelType) {
        switch (labelType) {
          case LabelType.mail:
            return Column(
              children: [
                label(
                  state,
                  LabelType.mail,
                  Icons.mail_outline_rounded,
                  'Email Address',
                  false,
                  state.mailCheckType,
                  state.errorEmailText,
                  state.showMailError,
                ),
                const SizedBox(height: 20),
              ],
            );
          case LabelType.user:
            return Column(
              children: [
                label(
                  state,
                  LabelType.user,
                  Icons.person,
                  'Username',
                  false,
                  CheckType.none,
                  state.errorUsernameText,
                  state.showUserError,
                ),
                const SizedBox(height: 20),
              ],
            );
          case LabelType.pass:
            return Column(
              children: [
                label(
                  state,
                  LabelType.pass,
                  Icons.lock_rounded,
                  'Password',
                  true,
                  CheckType.none,
                  state.errorPasswordText,
                  state.showPassError,
                ),
                const SizedBox(height: 20),
              ],
            );
        }
      }).toList(),
    );
  }

  Widget label(
    LoginPageState state,
    LabelType labelType,
    IconData leftIcon,
    String labelName,
    bool obscureText,
    CheckType checkType,
    String errorText,
    bool showError,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.dustyGray),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    Icon(leftIcon, color: AppColors.doveGray, size: 30),
                    const SizedBox(width: 30),
                    Container(height: 40, width: 1, color: AppColors.dustyGray),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labelName,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.doveGray,
                              fontFamily: 'RubikR',
                            ),
                          ),
                          TextFormField(
                            controller: _getController(labelType),
                            obscureText:
                                obscureText && _signBloc.state.obscurePass,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'RubikB',
                            ),
                            onChanged: (value) {
                              onTextChanged(labelType, value);
                            },
                          ),
                        ],
                      ),
                    ),
                    if (checkType != CheckType.none)
                      checkType == CheckType.check
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.seaGreen,
                            )
                          : const Icon(Icons.cancel, color: AppColors.red),
                    if (obscureText)
                      _signBloc.state.obscurePass
                          ? IconButton(
                              onPressed: () {
                                _signBloc.add(ObscurePass());
                              },
                              icon: const Icon(Icons.visibility_off_outlined),
                              color: AppColors.doveGray,
                              iconSize: 26,
                            )
                          : IconButton(
                              onPressed: () {
                                _signBloc.add(ObscurePass());
                              },
                              icon: const Icon(Icons.remove_red_eye_outlined),
                              color: AppColors.doveGray,
                              iconSize: 26,
                            ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              if (errorText.isNotEmpty && showError)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      errorText,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.red,
                        fontFamily: 'RubikR',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  TextEditingController _getController(LabelType labelType) {
    switch (labelType) {
      case LabelType.user:
        return _userController;
      case LabelType.mail:
        return _mailController;
      case LabelType.pass:
        return _passController;
    }
  }

  void onTextChanged(LabelType labelType, String text) {
    if (labelType == LabelType.mail) {
      _signBloc.add(MailChanged(text));
    } else if (labelType == LabelType.user) {
      _signBloc.add(UserChanged(text));
    } else if (labelType == LabelType.pass) {
      _signBloc.add(PassChanged(text));
    }
  }

  Widget createBlueButtonOrLoad(LoginPageState state) {
    return state.isLoading ? load() : blueButton();
  }

  Widget blueButton() {
    return GestureDetector(
      onTap: () {
        _signBloc.add(ButtonPressed(SignType.signUp));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double buttonWidth;
          if (constraints.maxWidth > 600) {
            buttonWidth = 600;
          } else {
            buttonWidth = constraints.maxWidth;
          }
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SizedBox(
              width: buttonWidth,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.blueRibbon,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _signBloc.state.buttonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'RubikR',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget load() {
    return const SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppColors.blueRibbon),
        backgroundColor: AppColors.alto,
        strokeWidth: 6,
      ),
    );
  }

  Widget createOrLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w;
        if (constraints.maxWidth > 488) {
          w = 488;
        } else {
          w = constraints.maxWidth;
        }
        final double width = (w - 69) / 2;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: IntrinsicWidth(
            child: Row(
              children: [
                createOneLine(width),
                const SizedBox(width: 50),
                const Text(
                  'or',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.dustyGray,
                    fontFamily: 'RubikB',
                  ),
                ),
                const SizedBox(width: 50),
                createOneLine(width),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget createOneLine(double width) {
    return Expanded(
      child: Container(height: 1, width: width, color: AppColors.dustyGray),
    );
  }

  Widget createOrButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        createOrButton(Colors.white, AppImages.google, true, googleClick),
        const SizedBox(width: 20),
        createOrButton(Colors.black, AppImages.apple, false, appleClick),
        const SizedBox(width: 20),
        createOrButton(
          AppColors.dodgerBlue,
          AppImages.facebook,
          false,
          facebookClick,
        ),
      ],
    );
  }

  Widget createOrButton(
    Color backcolor,
    String image,
    bool bord,
    void Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backcolor,
          borderRadius: BorderRadius.circular(30),
          border: bord
              ? Border.all(color: AppColors.dustyGray)
              : Border.all(color: Colors.transparent),
        ),
        child: Transform.scale(
          scale: 0.4,
          child: Image.asset(image, width: 60, height: 60, fit: BoxFit.contain),
        ),
      ),
    );
  }

  void appleClick() {
    print('Apple click');
  }

  void googleClick() {
    print('Google click');
  }

  void facebookClick() {
    print('Facebook click');
  }

  Widget createSuccess() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.check_circle_rounded),
      color: AppColors.seaGreen,
      iconSize: 100,
    );
  }
}