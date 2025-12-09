import 'package:flutter/material.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/types.dart';
import 'input_field_widget.dart';

class InputFields extends StatelessWidget {
  const InputFields({
    super.key,
    required this.state,
    required this.signBloc,
    required this.mailController,
    required this.userController,
    required this.passController,
  });
  final LoginPageState state;
  final SignBloc signBloc;
  final TextEditingController mailController;
  final TextEditingController userController;
  final TextEditingController passController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: state.labelTypes.map((labelType) {
        switch (labelType) {
          case LabelType.mail:
            return Column(
              children: [
                InputFieldWidget(
                  state: state,
                  labelType: LabelType.mail,
                  leftIcon: Icons.mail_outline_rounded,
                  labelName: 'Email Address',
                  obscureText: false,
                  checkType: state.mailCheckType,
                  errorText: state.errorEmailText,
                  showError: state.showMailError,
                  signBloc: signBloc,
                  controller: mailController,
                ),
                const SizedBox(height: 20),
              ],
            );
          case LabelType.user:
            return Column(
              children: [
                InputFieldWidget(
                  state: state,
                  labelType: LabelType.user,
                  leftIcon: Icons.person,
                  labelName: 'Username',
                  obscureText: false,
                  checkType: CheckType.none,
                  errorText: state.errorUsernameText,
                  showError: state.showUserError,
                  signBloc: signBloc,
                  controller: userController,
                ),
                const SizedBox(height: 20),
              ],
            );
          case LabelType.pass:
            return Column(
              children: [
                InputFieldWidget(
                  state: state,
                  labelType: LabelType.pass,
                  leftIcon: Icons.lock_rounded,
                  labelName: 'Password',
                  obscureText: true,
                  checkType: CheckType.none,
                  errorText: state.errorPasswordText,
                  showError: state.showPassError,
                  signBloc: signBloc,
                  controller: passController,
                ),
                const SizedBox(height: 20),
              ],
            );
        }
      }).toList(),
    );
  }
}
