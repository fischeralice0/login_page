import 'package:flutter/material.dart';

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
  bool signInOrSignUp = true;

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
                        final double buttonWidth = (constraints.maxWidth - 69) / 2;
                        return Container(
                          padding: const EdgeInsets.only(left: 3, top:3, bottom:3, right:3),
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            color: const Color(0xfff0eff2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    signInOrSignUp = false;
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
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double buttonWidth = constraints.maxWidth;
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