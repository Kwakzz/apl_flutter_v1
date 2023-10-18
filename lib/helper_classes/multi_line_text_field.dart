import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rich_field_controller/rich_field_controller.dart';


/// Class for multi-line text field.
class MultiLineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator <String>?  validator;
  final bool enabled;

  

  const MultiLineTextField(
    {
      super.key, 
      required this.controller,
      required this.labelText,
      this.validator,
      this.enabled = true,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: TextFormField (
        maxLines: null,
        controller: controller,
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
        validator: validator,
        enabled: enabled,
      ),
    );
  }
}


class RichTextField extends StatelessWidget {
  final RichFieldController controller;
  final String labelText;
  final FormFieldValidator <String>?  validator;
  final bool enabled;
  final RichFieldSelectionControls selectionControls;

  

  const RichTextField(
    {
       Key? key,
      required this.controller,
      required this.labelText,
      required this.selectionControls,
      this.validator,
      this.enabled = true,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: TextFormField (
        maxLines: null,
        controller: controller,
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
        validator: validator,
        enabled: enabled,
        selectionControls: selectionControls,
      ),
    );
  }
}
