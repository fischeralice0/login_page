import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../bloc/types.dart';

class SignTypeToggle extends StatelessWidget {
  const SignTypeToggle({
    super.key,
    required this.state,
    required this.signBloc,
    required this.context,
  });
  final LoginPageState state;
  final SignBloc signBloc;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: AppColors.athensGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth > 600
                ? 600
                : constraints.maxWidth;
            return SizedBox(
              width: maxWidth,
              child: Row(
                children: [
                  Expanded(child: PartOfSignButton(state: state, isSignIn:  true, signBloc: signBloc)),
                  const SizedBox(width: 3),
                  Expanded(child: PartOfSignButton(state: state, isSignIn:  false, signBloc: signBloc)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PartOfSignButton extends StatelessWidget {
  const PartOfSignButton({
    super.key,
    required this.state,
    required this.isSignIn,
    required this.signBloc,
  });
  final LoginPageState state;
  final bool isSignIn;
  final SignBloc signBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (state.isLoading == false) {
          if (state.signType == SignType.signIn && !isSignIn) {
            signBloc.add(SignTypeChanged(SignType.signUp));
          }
          if (state.signType == SignType.signUp && isSignIn) {
            signBloc.add(SignTypeChanged(SignType.signIn));
          }
        }
      },
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
    );
  }
}
