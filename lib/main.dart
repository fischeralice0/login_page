import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'colors_and_images.dart';
import 'mail_label.dart';
import 'sign_bloc.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login Page',
      home: MyLoginPage(signType: SignType.signIn),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.signType});
  final SignType signType;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  late SignBloc _signBloc;
  @override
  void initState() {
    super.initState();
    _signBloc = SignBloc();
    _signBloc.add(SignTypeChanged(widget.signType));
  }

  @override
  void dispose() {
    _signBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SignBloc, LoginPageState>(
          bloc: _signBloc,
          builder: (context, state) {
            return Column(
              children: [
                Padding(
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
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                            fontFamily: 'RubikB',
                          ),
                        ),
                        const Text(
                          'Please enter Your details',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.dustyGray,
                            fontFamily: 'RubikR',
                          ),
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final double w;
                            if (constraints.maxWidth > 600) {
                              w = 600;
                            } else {
                              w = constraints.maxWidth;
                            }
                            final double buttonWidth = (w - 69) / 2;
                            return Container(
                              padding: const EdgeInsets.only(
                                left: 3,
                                top: 3,
                                bottom: 3,
                                right: 3,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.athensGray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 534,
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _signBloc.add(SignTypeChanged(SignType.signIn));
                                      },
                                      child: SizedBox(
                                        width: buttonWidth,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: state.signType == SignType.signIn
                                                ? Colors.white
                                                : AppColors.athensGray,
                                            borderRadius: BorderRadius.circular(
                                              17,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Sign In',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontFamily: 'RubikR',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    GestureDetector(
                                      onTap: () {
                                        _signBloc.add(SignTypeChanged(SignType.signUp));
                                      },
                                      child: SizedBox(
                                        width: buttonWidth,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: state.signType == SignType.signUp
                                                ? Colors.white
                                                : AppColors.athensGray,
                                            borderRadius: BorderRadius.circular(
                                              17,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontFamily: 'RubikR',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final double buttonWidth;
                            if (constraints.maxWidth > 600) {
                              buttonWidth = 600;
                            } else {
                              buttonWidth = constraints.maxWidth;
                            }
                            return ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: Column(
                                children: state.labels.map((labelSettings) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: buttonWidth,
                                        child: MAILLABEL(
                                          leftIcon: labelSettings.leftIcon,
                                          labelName: labelSettings.labelName,
                                          hideText: labelSettings.hideText,
                                          showCheck: labelSettings.showCheck,
                                          labelType: labelSettings.labelType,
                                          signBloc: _signBloc,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        if (_signBloc.state.isProgress == false)
                          GestureDetector(
                            onTap: () {},
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final double buttonWidth;
                                if (constraints.maxWidth > 600) {
                                  buttonWidth = 600;
                                } else {
                                  buttonWidth = constraints.maxWidth;
                                }
                                return ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 600,
                                  ),
                                  child: SizedBox(
                                    width: buttonWidth,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueRibbon,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _signBloc.state.buttonText,
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
                          )
                        else
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.blueRibbon,
                              ),
                              backgroundColor: AppColors.alto,
                              strokeWidth: 6,
                            ),
                          ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final double w;
                            if (constraints.maxWidth > 488) {
                              w = 488;
                            } else {
                              w = constraints.maxWidth;
                            }
                            final double buttonWidth = (w - 69) / 2;
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        width: buttonWidth,
                                        color: AppColors.dustyGray,
                                      ),
                                    ),
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
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        width: buttonWidth,
                                        color: AppColors.dustyGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: AppColors.dustyGray),
                              ),
                              child: Transform.scale(
                                scale: 0.4,
                                child: Image.asset(
                                  AppImages.google,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Transform.scale(
                                scale: 0.4,
                                child: Image.asset(
                                  AppImages.apple,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.dodgerBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Transform.scale(
                                scale: 0.4,
                                child: Image.asset(
                                  AppImages.facebook,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
