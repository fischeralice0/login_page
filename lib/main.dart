import 'package:flutter/material.dart';
import 'mail_label.dart';
import 'verify_bloc.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login Page',
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({
    super.key
  });
  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  String username = '';
  String password = '';
  String email = '';

  bool signInOrSignUp = true;
  late List<MAILLABELController> mailLabelControllers1;
  late MAILLABELController mailLabelController2;
  bool firstCheckCompleted = false;
  bool secondCheckBegin = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(MyLoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeControllers();
    setState(() {
      firstCheckCompleted = false;
    });
  }

  void _initializeControllers() {
    if (signInOrSignUp) {
      mailLabelControllers1 = List.generate(3, (index) => MAILLABELController());
    } else {
      mailLabelControllers1 = List.generate(1, (index) => MAILLABELController());
      mailLabelController2 = MAILLABELController();
    }
  }

  void _enableErrorMessagesOrContinue() {
    bool allValid = true;
    for (final controller in mailLabelControllers1) {
      controller.showErrorMessage();
      if (!controller.isValid()) {
        allValid = false;
      }
    }
    if (allValid) {
      _updateVariablesFromControllers();
      setState(() {
        firstCheckCompleted = true;
        if (signInOrSignUp) {
          checkDetails();
        } else {
          checkMail();
        }
      });
    }
  }

  void _updateVariablesFromControllers() {
    if (signInOrSignUp) {
      username = mailLabelControllers1[0].myText();
      email = mailLabelControllers1[1].myText();
      password = mailLabelControllers1[2].myText();
    } else {
      email = mailLabelControllers1[0].myText();
      if (secondCheckBegin) {
        password = mailLabelController2.myText();
      }
    }
  }

  void checkMail(){
    //Тут будет обращение на сервер для проверки существования почты
    print('Проверка почты для: email=$email');
    setState(() {
      secondCheckBegin = true;
    });
  }
  void checkDetails(){
    //Тут будет обращение на сервер для проверки пользователя
    _updateVariablesFromControllers();
    print('Проверка для: email=$email, password=$password, username=$username');
    setState(() {
      secondCheckBegin = true;
    });
  }
  void checkPassword(){
    //Тут будет обращение на сервер для проверки пароля
    _updateVariablesFromControllers();
    print('Проверка пароля для: email=$email, password=$password');
    bool result = false;
    setState(() {
      mailLabelController2.showErrorMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: Column(
          children:[
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Projyn',
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xff000000),
                      fontFamily: 'RubikSB'
                    ),
                  ),
                ]
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    const Text('Welcome Back',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xff000000),
                        fontFamily: 'RubikB'
                      ),
                    ),
                    const Text('Please enter Your details',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff9a9a9a),
                        fontFamily: 'RubikR'
                      ),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double w;
                        if (constraints.maxWidth>600){w=600;}else{w=constraints.maxWidth;}
                        final double buttonWidth = (w - 69) / 2;
                        return Container(
                          padding: const EdgeInsets.only(left: 3, top:3, bottom:3, right:3),
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            color: const Color(0xfff0eff2),
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
                                    setState(() {
                                      signInOrSignUp = false;
                                      _initializeControllers();
                                    });
                                  },
                                  child: SizedBox(
                                    width: buttonWidth,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        color: signInOrSignUp ? const Color(0xfff0eff2): const Color(0xffffffff),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff000000),
                                            fontFamily: 'RubikR'
                                          ),
                                        ),
                                      ),
                                    )
                                  ),
                                ),
                                const SizedBox(width:3),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      signInOrSignUp = true;
                                      _initializeControllers();
                                    });
                                  },
                                  child: SizedBox(
                                    width: buttonWidth,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        color: signInOrSignUp ? const Color(0xffffffff): const Color(0xfff0eff2),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff000000),
                                            fontFamily: 'RubikR'
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            )
                          )
                        );
                      }
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
                        return !secondCheckBegin ? ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: !signInOrSignUp ?
                          SizedBox(
                            width: buttonWidth,
                            child: MAILLABEL(
                              leftIcon: Icons.mail_outline_rounded,
                              labelName: 'Email Address',
                              hiddenText: false,
                              verifyType: VerifyType.mail,
                              showCheck: true,
                              errorMessage: 'Invalid email address',
                              controller: mailLabelControllers1[0],
                            ),
                          )
                          :
                          Column(
                            children: [
                              SizedBox(
                                width: buttonWidth,
                                child: MAILLABEL(
                                  leftIcon: Icons.person,
                                  labelName: 'Username',
                                  hiddenText: false,
                                  verifyType: VerifyType.username,
                                  showCheck: false,
                                  minUserLen: 3,
                                  maxUserLen: 20,
                                  errorMessage: 'Username must be between 3 and 20 characters',
                                  controller: mailLabelControllers1[0],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: buttonWidth,
                                child: MAILLABEL(
                                  leftIcon: Icons.mail_outline_rounded,
                                  labelName: 'Email Address',
                                  hiddenText: false,
                                  verifyType: VerifyType.mail,
                                  showCheck: true,
                                  errorMessage: 'Invalid email address',
                                  controller: mailLabelControllers1[1],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: buttonWidth,
                                child: MAILLABEL(
                                  leftIcon: Icons.lock_rounded,
                                  labelName: 'Password',
                                  hiddenText: true,
                                  verifyType: VerifyType.password,
                                  showCheck: false,
                                  minPassLen: 8,
                                  errorMessage: 'Password must be at least 8 characters',
                                  controller: mailLabelControllers1[2],
                                ),
                              ),
                            ],
                          )
                        )
                        : ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 600,
                            ),
                            child: !signInOrSignUp
                              ? SizedBox(
                              width: buttonWidth,
                              child: MAILLABEL(
                                leftIcon: Icons.lock_rounded,
                                labelName: 'Password',
                                hiddenText: true,
                                verifyType: VerifyType.password,
                                showCheck: false,
                                minPassLen: 8,
                                errorMessage: 'Incorrect password',
                                controller: mailLabelController2,
                              ),
                            )
                            : Container()

                        );
                      }
                    ),
                    const SizedBox(height: 20),
                    !firstCheckCompleted || secondCheckBegin
                    ? GestureDetector(
                      onTap: () {
                        if (secondCheckBegin) {
                          if (!signInOrSignUp) {
                            checkPassword();
                          } else {
                            checkDetails();
                          }
                        } else {
                          _enableErrorMessagesOrContinue();
                        }
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
                            constraints: const BoxConstraints(
                              maxWidth: 600,
                            ),
                            child: SizedBox(
                              width: buttonWidth,
                              child:Container(
                                margin: const EdgeInsets.symmetric(horizontal: 30),
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xff0266ff),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  !signInOrSignUp ? (!secondCheckBegin?'Continue':'Sign In'):'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xffffffff),
                                    fontFamily: 'RubikR'
                                  ),
                                ),
                              )
                            )
                          );
                        }
                      ),
                    )
                    : const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xff0266ff)),
                        backgroundColor: Color(0xffe0e0e0),
                        strokeWidth: 6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double w;
                        if (constraints.maxWidth>488){w=488;}else{w=constraints.maxWidth;}
                        final double buttonWidth = (w - 69) / 2;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    width: buttonWidth,
                                    color: const Color(0xff9a9a9a),
                                  ),
                                ),
                                const SizedBox(width: 50),
                                const Text(
                                  'or',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff9a9a9a),
                                    fontFamily: 'RubikB'
                                  ),
                                ),
                                const SizedBox(width: 50),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    width: buttonWidth,
                                    color: const Color(0xff9a9a9a),
                                  ),
                                )
                              ]
                            )
                          )
                        );
                      }
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xff9a9a9a),
                            ),
                          ),
                          child: Transform.scale(
                            scale: 0.4,
                            child: Image.asset(
                              'images/google.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff000000),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Transform.scale(
                            scale: 0.4,
                            child: Image.asset(
                              'images/apple.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff1a79f1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Transform.scale(
                            scale: 0.4,
                            child: Image.asset(
                              'images/facebook.png',
                               width: 60,
                               height: 60,
                               fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ]
                    ),
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}