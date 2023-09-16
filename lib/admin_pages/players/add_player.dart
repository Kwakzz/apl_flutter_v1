import 'package:apl/admin.dart';
import 'package:apl/helper_classes/radio_form_field.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper_classes/text.dart';
import '../../helper_functions/convert_to_json.dart';
import '../../requests/players/add_player_req.dart';
import '../../requests/positions/get_positions_req.dart';
import '../../requests/teams/get_teams_req.dart';


/// This class is the stateful widget where the player can edit their details
class AddPlayer extends StatefulWidget {

  const AddPlayer(
    {
      super.key, 
      required this.pageName,
    }
  );

  final String pageName;
  

  @override
  State<AddPlayer> createState() => _AddPlayerState();

}

class _AddPlayerState extends State<AddPlayer> {

  String pageName = 'Add Player';
  final _formKey = GlobalKey<FormState>();

  // Teams for drop down list
  List<String> teamNames = [];
  // Positions for drop down list
  List<String> positions = [];

  // Date of birth
  DateTime? _selectedDate;

  // Controllers for the text fields
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  String _selectedGender = "Male";
  final _dateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  late String _selectedTeam;
  late String _selectedPosition;
  late String _isRetired = "Active";
  final _yearGroupController = TextEditingController();

  // Player's details
  String playerDetailsJson = '';


  /// This function shows a date picker when the user taps on the date of birth field.
  /// It updates the date of birth field with the selected date.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // get the teams for drop down list
    getTeamNames().then((value) {
      setState(() {
        teamNames = value;
      });
    });

    // get the positions for drop down list
    getPositionNames().then((value) {
      setState(() {
        positions = value;
      });
    });

    positions.add("None");

  }


  @override
  /// Dispose of the controllers when the widget is removed from the tree
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  
  @override
  Widget build (BuildContext context) {

    // dropdown list for teams
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
    SignUpDropdownFormField teamDropDown = 
    SignUpDropdownFormField(
      items: teamNames,
      labelText: "Team",
      onChanged: (newValue) {
        setState(() {
          _selectedTeam = newValue!;
        }
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a team';
        }
        return null;
      },
    );



    // dropdown list for positions
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
    SignUpDropdownFormField positionDropDown = 
    SignUpDropdownFormField(
      items: positions,
      labelText: "Position",
      onChanged: (newValue) {
        setState(() {
          _selectedPosition = newValue!;
        }
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a position';
        }
        return null;
      },
    );

    
   
    return MaterialApp(
      home: Scaffold (

        // app bar with back button and page name 
        appBar: CustomAppbar(
          pageName: pageName,
          icon: const Icon(Icons.arrow_back),
          prevContext: context,
        ),


        // add player form.
        // It contains the following fields:
        // - First name
        // - Last name
        // - Gender
        // - Date of birth
        // - Height
        // - Weight
        // - Team
        // - Position
        // - Is retired
        // - Year group
        body: Form(
          key: _formKey,
          child: ListView(
            // Children are the form fields
            children: [

              // First name
              SignUpTextField(
                controller: _fnameController,
                labelText: 'First Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),

              // Last name
              SignUpTextField(
                controller: _lnameController,
                labelText: 'Last Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),


              // Gender
              RadioFormField(
                labelText: "Gender", 
                firstValue: "Male", 
                secondValue: "Female", 
                selectedValue: _selectedGender, 
                onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              }
                              );
                            },
              ),

              // Date of birth
              SignUpTextField(
                controller: _dateController,
                labelText: 'Date of Birth',
                validator: (value) {
                  // Check if email is empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
                onTap: () {
                  _selectDate(context);
                },
              ),

              // Height
              SignUpTextField(
                controller: _heightController,
                labelText: 'Height',
                validator: (value) {
                  // Check if height is a number
                 
                  return null;
                },
                keyboardType: TextInputType.number,
               
              ),

              // Weight
              SignUpTextField(
                controller: _weightController,
                labelText: 'Weight',
                validator: (value) {
                  // Check if weight is an integer
                   
                  return null;
                },
              ),

              // Team
              teamDropDown,

              // Position
              positionDropDown,

              // Year group
              SignUpTextField(
                controller: _yearGroupController,
                labelText: 'Year Group',         
              ),
              

              // Status
              RadioFormField(
                labelText: "Status", 
                firstValue: "Active", 
                secondValue: "Retired", 
                selectedValue: _isRetired, 
                onChanged: (value) {
                              setState(() {
                                _isRetired = value!;
                              }
                              );
                            },
              ),

              // Continue button
              SignUpButton(
                text: "Finish",
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {

                    // convert is_retired to int
                    int isRetiredInt = 0;

                    if (_isRetired == "Retired") {
                      isRetiredInt = 1;
                    }                  

                    playerDetailsJson = convertNewPlayerDetailsToJson(
                    _fnameController.text, 
                    _lnameController.text, 
                    _selectedGender,
                    _dateController.text.toString(), 
                    _selectedPosition,
                    _selectedTeam,
                    // convert height and weight to int
                    int.tryParse(_heightController.text),
                    int.tryParse(_weightController.text),
                    _yearGroupController.text,
                    isRetiredInt
                    );

                    Map <String, dynamic> response = await addPlayer(playerDetailsJson);

                    if (!mounted) return;
     
                    if (response['status']) {

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
                          content: AppText(
                            text: response['message'],
                            fontWeight: FontWeight.w300, 
                            fontSize: 12, 
                            color: Colors.white
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      // Navigate to the next screen
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const Admin(
                            pageName: 'Admin',
                          ),
                        ),
                      ); 
                    } 
                    
                    else {
                      // Show error message
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return ErrorDialogueBox(
                            content: response['message'],
                          );
                        }
                      );
                    }                      
                  }
                },
              )
              
              
            ],
          ) 
        ),

        backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      )
    );
  }
}


