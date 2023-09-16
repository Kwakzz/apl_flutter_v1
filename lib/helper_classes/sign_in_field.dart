import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// Class for sign in text field.
/// It is used for all the text fields in the sign in form
class SignInTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;

  const SignInTextField({
    super.key, 
    required this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
      padding: const EdgeInsets.only(right: 14, left: 14, bottom: 7),
      color: const Color.fromARGB(255, 217, 217, 217),
      child: TextFormField (
        controller: controller,
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(200, 0, 0, 0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(50, 0, 0, 0),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(100, 0, 0, 0),
            ),
          ),
        ),
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.black,
        ),
        validator: validator,
      ),
    );
  }
}

/// Class for sign in password field.
/// It is used for all the password fields in the sign in form
class SignInPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;

  const SignInPasswordField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  State<SignInPasswordField> createState() => SignInPasswordFieldState();

}

class SignInPasswordFieldState extends State<SignInPasswordField> {

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
      padding: const EdgeInsets.only(right: 14, left: 14, bottom: 7),
      color: const Color.fromARGB(255, 217, 217, 217),
      child: TextFormField (
        controller: widget.controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
              size: 14,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Color.fromARGB(200, 0, 0, 0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(50, 0, 0, 0),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(100, 0, 0, 0),
            ),
          ),
        ),
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.black,
        ),
        validator: widget.validator,
      ),
    );
  }
}