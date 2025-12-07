class PasswordValidator {
  const PasswordValidator._();
  static String passCreateErrorText(String pass, int min) {
    if (pass.isEmpty) return 'This field is required';
    if (pass.length < min) return 'The password is too short';
    // Weak password ??
    return '';
  }
}