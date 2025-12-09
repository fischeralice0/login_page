import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/divider_with_text.dart';
import '../widgets/input_fields.dart';
import '../widgets/logo_widget.dart';
import '../widgets/primary_button_widget.dart';
import '../widgets/sign_type_toggle.dart';
import '../widgets/social_auth_buttons.dart';
import '../widgets/success_widget.dart';
import '../widgets/welcome_text_widget.dart';

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
                const LogoWidget(),
                Expanded(
                  child: Center(
                    child: state.success == false
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const WelcomeTextWidget(),
                                const SizedBox(height: 20),
                                SignTypeToggle(
                                  state: state,
                                  signBloc: _signBloc,
                                  context: context,
                                ),
                                const SizedBox(height: 20),
                                InputFields(
                                  state: state,
                                  signBloc: _signBloc,
                                  mailController: _mailController,
                                  userController: _userController,
                                  passController: _passController,
                                ),
                                PrimaryButtonOrLoadingIndicator(
                                  signBloc: _signBloc,
                                  state: state,
                                ),
                                const SizedBox(height: 20),
                                const DividerWithText(),
                                const SizedBox(height: 20),
                                const SocialAuthButtons(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          )
                        : const SuccessWidget(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
