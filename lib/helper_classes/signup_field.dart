import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helper_functions/valid_email.dart';


/// Class for sign up text field.
/// It is used for all the text fields in the sign up form
class SignUpTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator <String>?  validator;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final bool enabled;

  

  const SignUpTextField({
    super.key, 
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: TextFormField (
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.montserrat(
            fontSize: 13,
            color: const Color.fromARGB(200, 0, 0, 0),
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
        onTap: onTap,
        enabled: enabled,
      ),
    );
  }
}

/// Class for sign up text field.
/// It is used for all the text fields in the sign up form
class EmailSignUpTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const EmailSignUpTextField({
    super.key, 
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: TextFormField (
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
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
        validator: (value) {
          // Check if email field is empty
          if (value == null || value.isEmpty) {
            return 'Please enter your email address';
          }
          // Check if email matches the email regex
          if (!isEmailValid(value)) {
            return 'Please enter a valid email address';
          }
                  
          return null;
        },
      ),
    );
  }
}



/// Class for immutable text field.
/// This is used for all the text fields that are not editable
class ImmutableTextField extends StatelessWidget {
  final String labelText;
  final String? initialValue;

  const ImmutableTextField({
    super.key, 
    required this.labelText,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: TextFormField (
        initialValue: initialValue,
        enabled: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.black,
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
      ),
    );
  }
}

// ignore: must_be_immutable
/// Class for sign up password field.
/// It is used for the password field in the sign up form
class SignUpPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;

  const SignUpPasswordField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  State<SignUpPasswordField> createState() => SignUpPasswordFieldState();

}

class SignUpPasswordFieldState extends State<SignUpPasswordField> {

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(10),
      color: Colors.white,
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
          labelStyle: GoogleFonts.montserrat(
          fontSize: 13,
          color: const Color.fromARGB(200, 0, 0, 0),
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



