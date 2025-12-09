import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.check_circle_rounded),
      color: AppColors.seaGreen,
      iconSize: 100,
    );
  }
}
