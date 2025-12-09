import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}
