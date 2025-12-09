import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../bloc/types.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    super.key,
    required this.state,
    required this.labelType,
    required this.leftIcon,
    required this.labelName,
    required this.obscureText,
    required this.checkType,
    required this.errorText,
    required this.showError,
    required this.signBloc,
    required this.controller,
  });
  final LoginPageState state;
  final LabelType labelType;
  final IconData leftIcon;
  final String labelName;
  final bool obscureText;
  final CheckType checkType;
  final String errorText;
  final bool showError;
  final SignBloc signBloc;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
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
                            controller: controller,
                            obscureText:
                            obscureText && signBloc.state.obscurePass,
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
                      signBloc.state.obscurePass
                          ? IconButton(
                        onPressed: () {
                          signBloc.add(ObscurePass());
                        },
                        icon: const Icon(Icons.visibility_off_outlined),
                        color: AppColors.doveGray,
                        iconSize: 26,
                      )
                          : IconButton(
                        onPressed: () {
                          signBloc.add(ObscurePass());
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
  void onTextChanged(LabelType labelType, String text) {
    if (labelType == LabelType.mail) {
      signBloc.add(MailChanged(text));
    } else if (labelType == LabelType.user) {
      signBloc.add(UserChanged(text));
    } else if (labelType == LabelType.pass) {
      signBloc.add(PassChanged(text));
    }
  }
}
