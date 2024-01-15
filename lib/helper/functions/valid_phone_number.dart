/// This function validates a phone number based on a regular expression pattern.
bool isValidPhoneNumber(String value) {
  final RegExp mobileNumberRegex = RegExp(r'^[0-9]{10}$');
  return mobileNumberRegex.hasMatch(value);
}