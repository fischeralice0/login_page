import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../bloc/types.dart';

class PrimaryButtonOrLoadingIndicator extends StatelessWidget {
  const PrimaryButtonOrLoadingIndicator({
    super.key,
    required this.signBloc,
    required this.state,
  });
  final SignBloc signBloc;
  final LoginPageState state;

  @override
  Widget build(BuildContext context) {
    return state.isLoading
        ? const LoadingIndicator()
        : PrimaryButton(signBloc: signBloc);
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.signBloc});
  final SignBloc signBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        signBloc.add(ButtonPressed(SignType.signUp));
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
                  signBloc.state.buttonText,
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
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
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
}
