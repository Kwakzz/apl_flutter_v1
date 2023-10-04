import '../requests/if_user_exists.dart';

/// This function validates an email based on a regular expression pattern.
bool isEmailValid(String email) {
  // Regular expression pattern for email validation
  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$');

  return emailRegex.hasMatch(email);
}


Future<String?> validateEmail(String? value) async {
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  }
  if (!isEmailValid(value)) {
    return 'Please enter a valid email address';
  }
  final exists = await ifUserExists(value);
  if (exists) {
    return 'This email address is already registered';
  }
  return null;
}

