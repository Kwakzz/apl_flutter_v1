import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// Class for sign up text field
// It is used for all the text fields in the sign up form

class SignUpFormLabel extends StatelessWidget {
  final String labelText;

  const SignUpFormLabel({
    super.key, 
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7, top: 5),
      alignment: Alignment.centerLeft,
      child: Text(
        labelText,
        style: GoogleFonts.montserrat(
          fontSize: 15,
          color: const Color.fromARGB(200, 0, 0, 0),
        ),
      )
    );
  }

}

class SignInFormLabel extends StatelessWidget {
  final String labelText;

  const SignInFormLabel({
    super.key, 
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 10,),
      alignment: Alignment.centerLeft,
      child: Text(
        labelText,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: const Color.fromARGB(200, 0, 0, 0),
          fontWeight: FontWeight.w500
        ),
      )
    );
  }

}

class DropDownFormLabel extends StatelessWidget {
  final String labelText;

  const DropDownFormLabel({
    super.key, 
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        labelText,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: Colors.white,
          fontWeight: FontWeight.w500
        ),
      )
    );
  }

}