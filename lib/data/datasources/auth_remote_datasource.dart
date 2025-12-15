abstract class AuthRemoteDataSource {
  Future<String> mockSignIn(String mail, String pass);
  Future<List<String>> mockSignUp(String user, String mail, String pass);
  Future<String> mockCheckEmail(String mail);
}

class AuthRemoteDataSourceError implements AuthRemoteDataSource {
  const AuthRemoteDataSourceError();
  @override
  Future<String> mockSignIn(String mail, String pass) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String result = 'Incorrect password';
    return result;
  }
  @override
  Future<List<String>> mockSignUp(String user, String mail, String pass) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String mailError = 'This email already used';
    const String passError = 'Weak password';
    const String userError = 'This username already used';
    const List<String> result = [mailError, passError, userError];
    return result;
  }
  @override
  Future<String> mockCheckEmail(String mail) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String result = 'This email is not registered';
    return result;
  }
}

class AuthRemoteDataSourceOk implements AuthRemoteDataSource {
  const AuthRemoteDataSourceOk();
  @override
  Future<String> mockSignIn(String mail, String pass) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String result = '';
    return result;
  }
  @override
  Future<List<String>> mockSignUp(String user, String mail, String pass) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String mailError = '';
    const String passError = '';
    const String userError = '';
    const List<String> result = [mailError, passError, userError];
    return result;
  }
  @override
  Future<String> mockCheckEmail(String mail) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    const String result = '';
    return result;
  }
}
