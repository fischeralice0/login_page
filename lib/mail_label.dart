import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'verify_bloc.dart';
import 'colors_and_images.dart';

class MAILLABEL extends StatefulWidget {
  const MAILLABEL({
    super.key,
    required this.leftIcon,        // Иконка
    required this.labelName,       // Имя поля
    required this.hiddenText,      // Скрываем ли текст
    required this.verifyType,      // Способ проверки текста
    required this.showCheck,       // Показывать красный крестик или зелёную галочку при verifyType != none
    this.minPassLen = 8,
    this.minUserLen = 3,
    this.maxUserLen = 20,
    this.errorMessage = '',
    this.controller,
  });

  final IconData leftIcon;
  final String labelName;
  final bool hiddenText;
  final VerifyType verifyType;
  final bool showCheck;
  final int minPassLen;
  final int minUserLen;
  final int maxUserLen;
  final String errorMessage;
  final MAILLABELController? controller;

  @override
  State<MAILLABEL> createState() => _MAILLABELState();
}

class MAILLABELController {
  late _MAILLABELState _state;
  void showErrorMessage() {
    _state.showErrorMessage();
  }
  void _attach(_MAILLABELState state) {
    _state = state;
  }
  bool isValid() {
    return _state.isValid();
  }
  String myText() {
    return _state._controller.text;
  }
  void newErrorMessage(String text) {
    _state.newErrorMessage(text);
  }
}

class _MAILLABELState extends State<MAILLABEL> {
  final TextEditingController _controller = TextEditingController();
  bool _obscure = true;
  late VerifyBloc _labelBloc;
  bool showMessage = false;
  String _currentErrorMessage = '';

  void showErrorMessage() {
    setState(() {
      showMessage = true;
    });
  }

  bool isValid() {
    return _labelBloc.state is LabelValid;
  }

  void newErrorMessage(String text) {
    _currentErrorMessage = text;
  }

  @override
  void didUpdateWidget(MAILLABEL oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.verifyType != widget.verifyType) {
      _controller.clear();
      _labelBloc.add(LabelValueChange(''));
    }
  }

  @override
  void initState() {
    super.initState();
    _currentErrorMessage = widget.errorMessage;
    _labelBloc = VerifyBloc(
      verifyType: widget.verifyType,
      minPassLen: widget.minPassLen,
      minUserLen: widget.minUserLen,
      maxUserLen: widget.maxUserLen,
    );

    if (widget.controller != null) {
      widget.controller!._attach(this);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _labelBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _labelBloc,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.dustyGray,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  Icon(widget.leftIcon, color: AppColors.doveGray, size: 30,),
                  const SizedBox(width: 30),
                  Container(
                    height: 40,
                    width: 1,
                    color: AppColors.dustyGray,
                  ),
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
                                  fontFamily: 'RubikR'
                              ),
                            ),
                            TextFormField(
                              controller: _controller,
                              obscureText: widget.hiddenText && _obscure,
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
                                  fontFamily: 'RubikB'
                              ),
                              onChanged: (value) {
                                _labelBloc.add(LabelValueChange(value));
                                showMessage = false;
                                setState(() {});
                              },
                            ),
                          ]
                      )
                  ),
                  if (widget.verifyType != VerifyType.none && widget.showCheck)
                    BlocBuilder<VerifyBloc, LabelValidationState>(
                      builder: (context, state) {
                        if (_controller.text.isEmpty) return const SizedBox();

                        return state is LabelValid
                            ? const Icon(Icons.check_circle_rounded, color: AppColors.seaGreen)
                            : const Icon(Icons.cancel, color: AppColors.red);
                      },
                    ),
                  if (widget.hiddenText)
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
              )
          ),
          if (widget.verifyType != VerifyType.none)
            BlocBuilder<VerifyBloc, LabelValidationState>(
              builder: (context, state) {
                if (showMessage && state is! LabelValid && _controller.text.isNotEmpty){
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        _currentErrorMessage,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.red,
                          fontFamily: 'RubikR'
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
        ]
      )
    );
  }
}