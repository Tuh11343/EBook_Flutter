class RegexPattern {
  // Regular expression for a password with at least 6 characters
  static final RegExp passwordRegExp = RegExp(r'^.{6,}$');
  static final RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

  static bool validatePassword(String password) {
    return passwordRegExp.hasMatch(password);
  }

  static bool validateEmail(String email) {
    return gmailRegex.hasMatch(email);
  }
}
