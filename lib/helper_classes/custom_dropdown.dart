import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// ignore: must_be_immutable
class SignUpDropdownFormField extends StatefulWidget {

  List items;
  String labelText;
  Function(String?) onChanged;
  String? selectedValue;
  final FormFieldValidator <String>?  validator;

  SignUpDropdownFormField({
    Key? key,
    required this.items,
    required this.labelText,
    required this.onChanged,
    this.selectedValue,
    this.validator,
  }) : super(key: key);

  @override
  SignUpDropdownFormFieldState createState() => SignUpDropdownFormFieldState();

}

class SignUpDropdownFormFieldState extends State<SignUpDropdownFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 12),
          child: Container(
            color: Colors.white,
          child: DropdownButtonFormField<String>(
            value: widget.selectedValue,
            onChanged: widget.onChanged,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.black,
            ),
            iconSize: 20,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(25),
              hintText: widget.labelText,
              hintStyle: GoogleFonts.montserrat(
                fontSize: 12,
                color: const Color.fromARGB(255, 82, 82, 82),
              ),
            ),
            dropdownColor: Colors.white,
            items: widget.items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            validator: widget.validator,
          ),
        )
        ),
      ],
    );
  }
}


// ignore: must_be_immutable
class MyDropdownFormField extends StatefulWidget {

  List items;
  String labelText;
  String? hintText;
  Function(String?) onChanged;
  String? selectedValue;
  final FormFieldValidator <String>?  validator;

  MyDropdownFormField({
    Key? key,
    required this.items,
    required this.labelText,
    this.hintText = '',
    required this.onChanged,
    this.selectedValue,
    this.validator,
  }) : super(key: key);

  @override
  MyDropdownFormFieldState createState() => MyDropdownFormFieldState();

}

class MyDropdownFormFieldState extends State<MyDropdownFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.95,
          margin: const EdgeInsets.only(top: 12,),
          child: Container(
            color: Colors.white,
            child: DropdownButtonFormField<String>(
              value: widget.selectedValue,
              onChanged: widget.onChanged,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.black,
              ),
              iconSize: 20,

              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top:5, bottom:5, left: 10),
                labelText: widget.labelText,
                labelStyle: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: const Color.fromARGB(255, 82, 82, 82),
                  height: 0
                ),
                hintText: widget.hintText,
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.black,
                  height: 2
                ),
              ),
              dropdownColor: Colors.white,
              items: widget.items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              validator: widget.validator,
            ),
          )
        ),
      ],
    );
  }
}
