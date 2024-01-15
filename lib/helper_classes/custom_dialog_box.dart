import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper_classes/signup_field.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:flutter/material.dart';

/// Class for adding player to starting XI dialog box
// ignore: must_be_immutable
class AddPlayerToStartingXIDialogBox extends StatelessWidget {

  const AddPlayerToStartingXIDialogBox (
    {
      super.key,
      required this.players,
      required this.positions,
      required this.playerDropDownOnChanged,
      required this.positionDropDownOnChanged,
      required this.submitButtonOnPressed,
      required this.positionValidator,
      required this.formKey,
    }
  );

  final GlobalKey <FormState> formKey;
  final List <String> players;
  final List <String> positions;
  final Function (String?) playerDropDownOnChanged;
  final Function (String?) positionDropDownOnChanged;
  final Function submitButtonOnPressed;
  final FormFieldValidator <String?> positionValidator;

  @override
  Widget build(BuildContext context) {

    return AlertDialog (

      title: const AppText(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        text: "Add Player to Starting XI",
      ),

      content: Form(
        key: formKey,
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: [

            MyDropdownFormField(
              items: players, 
              labelText: "Player", 
              onChanged: playerDropDownOnChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose a player';
                }
                return null;
              },
            ),

            MyDropdownFormField(
              items: positions, 
              labelText: "Position", 
              onChanged: positionDropDownOnChanged,
              validator: positionValidator,
            ),
            
          ]
        )
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Cancel",
          ),
        ),

        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              submitButtonOnPressed();
              Navigator.of(context).pop();
            }
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Submit",
          ),
        ),
      ],
      
    );
  }
}

/// class for deleting confirmation dialog box
class DeleteConfirmationDialogBox extends StatelessWidget {

  const DeleteConfirmationDialogBox (
    {
      super.key,
      required this.title,
      required this.content,
      required this.onPressed,
    }
  );

  final String title;
  final String content;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppText(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        text: title,
      ),

      content: AppText(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        text: content,
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Keep",
          ),
        ),

        TextButton(
          onPressed: () {
            onPressed();
            Navigator.of(context).pop();
          }, 
          child: const AppText(
            color: Colors.red,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Delete",
          ),
        ),
      ],
      
    );
  }
}

/// class for deleting confirmation dialog box
class ActionConfirmationDialogBox extends StatelessWidget {

  const ActionConfirmationDialogBox (
    {
      super.key,
      required this.title,
      required this.content,
      required this.onPressed,
    }
  );

  final String title;
  final String content;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppText(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        text: title,
      ),

      content: AppText(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        text: content,
      ),

      actions: [
        // Yes
        TextButton(
          onPressed: () {
            onPressed();
          }, 
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 0, 53, 91),
            ),
          ),
          child: const AppText(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Yes",
          ),
        ),

        // No
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>( Colors.white)
          ),
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "No",
          ),
        ),

        
      ],
      
    );
  }
}


/// Add Goal Dialog Box Class
// ignore: must_be_immutable
class AddGoalDialogBox extends StatelessWidget {

  const AddGoalDialogBox (
    {
      super.key,
      required this.teamDropDownList,
      required this.goalScorersDropDownList,
      required this.assistDropDownList,
      required this.teamDropDownOnChanged,
      required this.goalDropDownOnChanged,
      required this.assistDropDownOnChanged,
      required this.submitButtonOnPressed,
      required this.teamValidator,
      required this.goalValidator,
      required this.assistValidator,
      required this.minuteScoredController,
      required this.formKey,
    }
  );

  final GlobalKey <FormState> formKey;
  final List <String> teamDropDownList;
  final List <String> goalScorersDropDownList;
  final List <String> assistDropDownList;
  final Function (String?) teamDropDownOnChanged;
  final Function (String?) goalDropDownOnChanged;
  final Function (String?) assistDropDownOnChanged;
  final Function submitButtonOnPressed;
  final FormFieldValidator <String?> teamValidator;
  final FormFieldValidator <String?> goalValidator;
  final FormFieldValidator <String?> assistValidator;
  final TextEditingController minuteScoredController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const AppText(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        text: "Add Goal",
      ),

      content: Form(
        key: formKey,
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: [

            MyDropdownFormField(
              items: teamDropDownList, 
              labelText: "Team", 
              onChanged: teamDropDownOnChanged,
              validator: teamValidator,
            ),

            MyDropdownFormField(
              items: goalScorersDropDownList, 
              labelText: "Goal", 
              onChanged: goalDropDownOnChanged,
              validator: goalValidator,
            ),

            MyDropdownFormField(
              items: assistDropDownList, 
              labelText: "Assist", 
              onChanged: assistDropDownOnChanged,
              validator: assistValidator,
            ),

            SignUpTextField(
              controller: minuteScoredController,
              labelText: "Minute Scored",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter the minute the goal was scored";
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            
          ]
        )
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Cancel",
          ),
        ),

        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              submitButtonOnPressed();
              Navigator.of(context).pop();
            }
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Submit",
          ),
        ),
      ],
      
    );
  }

}


// ignore: must_be_immutable
class AddStandingsTeamDialogBox extends StatelessWidget {

  const AddStandingsTeamDialogBox (
    {
      super.key,
      required this.teamDropDownList,
      required this.teamValidator,
      required this.formKey,
      required this.submitButtonOnPressed,
      required this.teamDropDownOnChanged
    }
  );

  final GlobalKey <FormState> formKey;
  final List <String> teamDropDownList;
  final Function (String?) teamDropDownOnChanged;
  final Function submitButtonOnPressed;
  final FormFieldValidator <String?> teamValidator;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const AppText(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        text: "Add Standings Team",
      ),

      content: Form(
        key: formKey,
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: [

            MyDropdownFormField(
              items: teamDropDownList, 
              labelText: "Team", 
              onChanged: teamDropDownOnChanged,
              validator: teamValidator,
            ),
            
          ]
        )
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Cancel",
          ),
        ),

        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              submitButtonOnPressed();
              Navigator.of(context).pop();
            }
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Submit",
          ),
        ),
      ],
      
    );
  }

}

// ignore: must_be_immutable
class TransferDialogueBox extends StatelessWidget {

  TransferDialogueBox (
    {
      super.key,
      required this.teamDropDownList,
      required this.teamValidator,
      required this.transferTypeValidator,
      required this.formKey,
      required this.submitButtonOnPressed,
      required this.teamDropDownOnChanged,
      required this.transferTypeOnChanged
    }
  );

  final GlobalKey <FormState> formKey;
  final List <String> teamDropDownList;
  final Function (String?) teamDropDownOnChanged;
  final Function submitButtonOnPressed;
  final FormFieldValidator <String?> teamValidator;
  final FormFieldValidator <String?> transferTypeValidator;
  final Function (String?) transferTypeOnChanged;

  final transferTypes = [
    "Permanent",
    "Loan",
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const AppText(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        text: "Transfer",
      ),

      content: Form(
        key: formKey,
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: [

            MyDropdownFormField(
              items: teamDropDownList, 
              labelText: "Team", 
              onChanged: teamDropDownOnChanged,
              validator: teamValidator,
            ),

            MyDropdownFormField(
              items: transferTypes,
              labelText: "Transfer Type", 
              onChanged: transferTypeOnChanged,
              validator: transferTypeValidator,
            ),
            
          ]
        )
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Cancel",
          ),
        ),

        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              submitButtonOnPressed();
              Navigator.of(context).pop();
            }
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Submit",
          ),
        ),
      ],
      
    );
  }

}



/// Error dialogue box
class ErrorDialogueBox extends StatelessWidget {

  ErrorDialogueBox (
    {
      super.key,
      required this.content,
      this.text = "Error",
    }
  );

  String text;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppText(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        text: text
      ),

      content: AppText(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        text: content,
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const AppText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            text: "Ok",
          ),
        ),
      ],
      
    );
  }
}


class SelectMOTMDialogBox extends StatelessWidget {

  SelectMOTMDialogBox (
    {
      super.key,
      required this.playersDropDown,
      required this.formKey,
      required this.onSubmit
    }
  );

  final GlobalKey <FormState> formKey;
  final SignUpDropdownFormField playersDropDown;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const AppText(
        text: "Select MOTM",
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            playersDropDown,
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const AppText(
            text: "Cancel",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              onSubmit();
              Navigator.of(context).pop();
            }
          }, 
          child: const AppText(
            text: "Select",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

}

