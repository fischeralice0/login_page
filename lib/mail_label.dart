import 'package:flutter/material.dart';

class MAILLABEL extends StatefulWidget {
  const MAILLABEL({
    super.key,
    required this.leftIcon,
    required this.labelName,
    required this.verifyMail,
    required this.hiddenPassword,
  });
  final IconData leftIcon;
  final String labelName;
  final bool verifyMail;  // Проверяем ли формат адреса электронной почты
  final bool hiddenPassword;
  @override
  State<MAILLABEL> createState() => _MAILLABELState();
}
class _MAILLABELState extends State<MAILLABEL> {
  final TextEditingController _mailController = TextEditingController();
  bool _obscure = true;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _mailController.dispose();
    super.dispose();
  }

  bool _isMail() {
    if (_mailController.text.isEmpty) return false;
    if (_mailController.text.length > 254) return false;
    final parts = _mailController.text.split('@');
    if (parts.length != 2) return false;
    if (parts[0].isEmpty || parts[0].length > 64) return false;
    if (parts[1].isEmpty || parts[1].length > 253) return false;
    if (parts[1].contains('..')) return false;
    if (parts[1].startsWith('.') || parts[1].endsWith('.')) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(_mailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xff9a9a9a),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 30),
          Icon(widget.leftIcon, color: const Color(0xff686868), size: 30,),
          const SizedBox(width: 30),
          Container(
              height: 40,
              width: 1,
              color: const Color(0xff9a9a9a),
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
                      color: Color(0xff686868),
                      fontFamily: 'RubikR'
                  ),
                ),
                TextFormField(
                  controller: _mailController,
                  obscureText:  widget.hiddenPassword && _obscure,
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
                      color: Color(0xff000000),
                      fontFamily: 'RubikB'
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ]
          )
        ),
          if (widget.verifyMail && _mailController.text.isNotEmpty)
            _isMail()
              ? const Icon(Icons.check_circle_rounded, color: Color(0xff298b4b))
              : const Icon(Icons.cancel, color: Color(0xffff0000)),
          if (widget.hiddenPassword)
            _obscure
              ? IconButton(
                  onPressed: () {
                    _obscure=false;
                    setState(() {});
                  },
                  icon: const Icon(Icons.visibility_off_outlined),
                  color: const Color(0xff686868),
                  iconSize: 26,
                )
              : IconButton(
                  onPressed: () {
                    _obscure=true;
                    setState(() {});
                  },
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  color: const Color(0xff686868),
                  iconSize: 26,
                ),
          SizedBox(width: widget.verifyMail?28:20),
        ],
      )
    );
  }
}