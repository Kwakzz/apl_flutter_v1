import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Class for sign up text field.
/// It is used for all the text fields in the sign up form
class SearchField extends StatelessWidget {
  final String labelText;
  void Function(String?) onChanged;

  SearchField({
    super.key, 
    required this.labelText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      margin: const EdgeInsets.only(top:10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      alignment: Alignment.centerRight,
      child: TextFormField (
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.black,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color.fromARGB(200, 0, 0, 0),
            fontSize: 13
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
        onChanged: onChanged,
      ),
    );
  }
}

