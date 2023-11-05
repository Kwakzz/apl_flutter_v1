import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:flutter/material.dart';

class ErrorHandling {

  
  static void showError(String errorMessage, BuildContext context, text) {
    showDialog(
      context: context, 
      builder: (context) {
        return ErrorDialogueBox(
          content: errorMessage, 
          text: text,
        );
      }
    );
  }
}