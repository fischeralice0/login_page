class AuthRemoteDataSource {
  const AuthRemoteDataSource();
  Future<String> mockSignIn(String mail, String pass) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String result = 'Incorrect password';
    return result;
  }

  Future<List<String>> mockSignUp(String user, String mail, String pass) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String mailError = 'This email already used';
    const String passError = 'Weak password';
    const String userError = 'This username already used';
    const List<String> result = [mailError, passError, userError];
    return result;
  }

  Future<String> mockCheckEmail(String mail) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String result = 'This email is not registered';
    return result;
  }
}
