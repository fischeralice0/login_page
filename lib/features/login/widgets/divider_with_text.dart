import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.dustyGray)),
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
            Expanded(child: Container(height: 1, color: AppColors.dustyGray)),
          ],
        ),
      ),
    );
  }
}
