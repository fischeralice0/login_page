import 'package:login_page/features/login/bloc/sign_bloc.dart';

class EmailValidator {
  static String mailCreateErrorText(String mail) {
    if (mail.isEmpty) return 'This field is required';
    if (mail.length > 254) return 'This text is too long';
    final parts = mail.split('@');
    if (parts.length > 2) return 'Too much @';
    if (parts.length < 2) return '@ required';
    if (parts[0].isEmpty) return 'Username required';
    if (parts[0].length > 64) return 'Username is too long';
    if (parts[1].isEmpty) return 'Domain required';
    if (parts[1].length > 253) return 'Domain is too long';
    if (parts[1].contains('..')) return 'You cannot use two periods in a row';
    if (parts[1].startsWith('.')) return 'You cannot use a period after @';
    if (parts[1].endsWith('.')) {
      return 'An email address cannot end with a period';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (emailRegex.hasMatch(mail)) {
      return '';
    } else {
      return 'Email address format error';
    }
  }

  static CheckType mailCreateCheckType(String mail) {
    if (mail.isEmpty) return CheckType.none;
    if (mail.length > 254) return CheckType.cross;
    final parts = mail.split('@');
    if (parts.length > 2) return CheckType.cross;
    if (parts.length < 2) return CheckType.cross;
    if (parts[0].isEmpty) return CheckType.cross;
    if (parts[0].length > 64) return CheckType.cross;
    if (parts[1].isEmpty) return CheckType.cross;
    if (parts[1].length > 253) return CheckType.cross;
    if (parts[1].contains('..')) return CheckType.cross;
    if (parts[1].startsWith('.')) return CheckType.cross;
    if (parts[1].endsWith('.')) return CheckType.cross;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (emailRegex.hasMatch(mail)) {
      return CheckType.check;
    } else {
      return CheckType.cross;
    }
  }
}

