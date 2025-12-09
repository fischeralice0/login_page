class UsernameValidator {
  const UsernameValidator._();
  static String userCreateErrorText(String user, int min, int max) {
    if (user.isEmpty) return 'This field is required';
    if (user.length < min) return 'The username is too short';
    if (user.length > max) return 'The username is too long';
    return '';
  }
}
