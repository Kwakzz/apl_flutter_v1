import 'package:flutter/material.dart';
import 'custom_radio_tile.dart';
import 'form_label.dart';


/// Class for sign up text field.
/// It is used for fields with radio buttons

class RadioFormField extends StatelessWidget {

  const RadioFormField(
    {
      super.key,
      required this.labelText,
      required this.firstValue,
      required this.secondValue,
      required this.selectedValue,
      required this.onChanged,
    }
  );

  // label text
  final String labelText;
  final String firstValue;
  final String secondValue;
  final String selectedValue;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          // title
          SignUpFormLabel(
            labelText: labelText
          ),
          Row (
            children: [
              Expanded(
                // First Value
                child: CustomRadioListTile(
                  title: firstValue, 
                  value: firstValue, 
                  groupValue: selectedValue, 
                  onChanged: onChanged
              )
            ),

            Expanded(
            // Second Value
              child: CustomRadioListTile(
                title: secondValue, 
                value: secondValue, 
                groupValue: selectedValue, 
                onChanged: onChanged
              )
            )
          ]
        )
      ]
    )
  );
}

}