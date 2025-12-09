import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WelcomeTextWidget extends StatelessWidget {
  const WelcomeTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}
