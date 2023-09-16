import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Class for Radio list tile
// ignore: must_be_immutable
class CustomRadioListTile extends StatelessWidget {
  String title;
  String value;
  String groupValue;
  void Function (String?) onChanged;

  CustomRadioListTile(
    {
      super.key, 
      required this.title,
      required this.value,
      required this.groupValue,
      required this.onChanged,
    }
  );

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          color: const Color.fromARGB(200, 0, 0, 0),
        ),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: const Color.fromARGB(255, 0, 53, 91)
    );
  }
}



