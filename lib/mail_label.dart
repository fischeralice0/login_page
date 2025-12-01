import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'colors_and_images.dart';
import 'sign_bloc.dart';

class MAILLABEL extends StatefulWidget {
  const MAILLABEL({
    super.key,
    required this.leftIcon, // Иконка
    required this.labelName, // Имя поля
    required this.hideText, // Можно ли скрыть/показать текст
    required this.showCheck, // Показывать красный кретсик или зелёную галочку
    this.errorText = '',
    this.controller,
    required this.labelType,
    required this.signBloc,
  });

  final IconData leftIcon;
  final String labelName;
  final bool hideText;
  final bool showCheck;
  final String errorText;
  final MAILLABELController? controller;
  final LabelType labelType;
  final SignBloc signBloc;

  @override
  State<MAILLABEL> createState() => _MAILLABELState();
}

class MAILLABELController {
  late _MAILLABELState _state;

  void attach(_MAILLABELState state) {
    _state = state;
  }

  void newErrorText(String text) {
    _state.newErrorText(text);
  }
}

class _MAILLABELState extends State<MAILLABEL> {
  final TextEditingController _controller = TextEditingController();
  bool _obscure = true;
  String _currentErrorText = '';
  late SignBloc _signBloc;



  void newErrorText(String text) {
    _currentErrorText = text;
  }

  @override
  void initState() {
    super.initState();
    _currentErrorText = widget.errorText;
    _resetController();

    if (widget.controller != null) {
      widget.controller!.attach(this);
    }
  }
  void _resetController() {
    final currentState = widget.signBloc.state;
    switch (widget.labelType) {
      case LabelType.user:
        _controller.text = currentState.username;
        break;
      case LabelType.mail:
        _controller.text = currentState.email;
        break;
      case LabelType.pass:
        _controller.text = currentState.password;
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.dustyGray),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30),
              Icon(widget.leftIcon, color: AppColors.doveGray, size: 30),
              const SizedBox(width: 30),
              Container(height: 40, width: 1, color: AppColors.dustyGray),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.labelName,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.doveGray,
                        fontFamily: 'RubikR',
                      ),
                    ),
                    TextFormField(
                      controller: _controller,
                      obscureText: widget.hideText && _obscure,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'RubikB',
                      ),
                      onChanged: (value) {
                        _signBloc.add(
                          LabelTextChanged(widget.labelType, value),
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              if (widget.showCheck)
                BlocBuilder<SignBloc, LoginPageState>(
                  bloc: widget.signBloc,
                  builder: (context, state) {
                    if (_controller.text.isEmpty) return const SizedBox();
                    return (_currentErrorText == '')
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.seaGreen,
                          )
                        : const Icon(Icons.cancel, color: AppColors.red);
                  },
                ),
              if (widget.hideText)
                _obscure
                    ? IconButton(
                        onPressed: () {
                          _obscure = false;
                          setState(() {});
                        },
                        icon: const Icon(Icons.visibility_off_outlined),
                        color: AppColors.doveGray,
                        iconSize: 26,
                      )
                    : IconButton(
                        onPressed: () {
                          _obscure = true;
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        color: AppColors.doveGray,
                        iconSize: 26,
                      ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        if (_currentErrorText != '')
          BlocBuilder<SignBloc, LoginPageState>(
            bloc: widget.signBloc,
            builder: (context, state) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    _currentErrorText,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.red,
                      fontFamily: 'RubikR',
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
