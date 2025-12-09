import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthButton(
          backcolor: Colors.white,
          image: AppImages.google,
          bord: true,
          onTap: googleClick,
        ),
        SizedBox(width: 20),
        AuthButton(
          backcolor: Colors.black,
          image: AppImages.apple,
          bord: false,
          onTap: appleClick,
        ),
        SizedBox(width: 20),
        AuthButton(
          backcolor: AppColors.dodgerBlue,
          image: AppImages.facebook,
          bord: false,
          onTap: facebookClick,
        ),
      ],
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.backcolor,
    required this.image,
    required this.bord,
    required this.onTap,
  });

  final Color backcolor;
  final String image;
  final bool bord;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
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
}

void appleClick() {}

void googleClick() {}

void facebookClick() {}
