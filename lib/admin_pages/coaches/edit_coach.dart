import 'package:apl/pages/nav_tabs/admin.dart';
import 'package:apl/helper_classes/radio_form_field.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/requests/coach/edit_coach_req.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper/widgets/text.dart';
import '../../helper/functions/convert_to_json.dart';
import '../../requests/teams/get_teams_req.dart';


/// This class is the stateful widget where the player can edit their details
class EditCoach extends StatefulWidget {

  const EditCoach(
    {
      super.key, 
      required this.pageName,
      required this.coachDetailsMap
    }
  );

  final String pageName;
  // Coach's details
  final Map <String, dynamic> coachDetailsMap;

  

  @override
  State<EditCoach> createState() => _EditCoachState();

}

class _EditCoachState extends State<EditCoach> {

  String pageName = 'Edit Coach';
  final _formKey = GlobalKey<FormState>();

  // Teams for drop down list
  List<String> teamNames = [];
  // Positions for drop down list
  List<String> positions = [];

  // Date of birth
  DateTime? _selectedDate;

  // Coach's details in JSON format
  String coachDetailsJson = "";

  // Controllers for the text fields
  // They are initialized with the user's values
  // so that the admin can edit them. 
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  late String _selectedGender;
  late TextEditingController _dateController;
  late String _selectedTeam;
  late String _isRetired;
  late TextEditingController _yearGroupController;

  // Player's details
  Map <String, dynamic> playerDetailsMap = {};
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

    // initialize the controllers with the user's details
    _fnameController = TextEditingController(
      text: widget.coachDetailsMap['fname']
      );
    _lnameController = TextEditingController(
      text: widget.coachDetailsMap['lname']
    );
    _selectedGender = widget.coachDetailsMap['gender'];
    _dateController = TextEditingController(
      text: widget.coachDetailsMap['date_of_birth']
    );
    _selectedTeam = widget.coachDetailsMap['team_name'];
    _yearGroupController = TextEditingController(
    text: widget.coachDetailsMap['year_group'].toString()
    );
    if (widget.coachDetailsMap['is_retired'] == 1) {
      _isRetired = 'Retired';
    } 
    else {
      _isRetired = 'Active';
    }
  }


  @override
  /// Dispose of the controllers when the widget is removed from the tree
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
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
      }
    );

    // the selected value is changed to the user's team if the team is not null
    if (widget.coachDetailsMap['team_name'] != "None") {
      teamDropDown.selectedValue = widget.coachDetailsMap['team_name'];
    }

   
    return MaterialApp(
      home: Scaffold (

        // app bar with back button and page name 
        appBar: CustomAppbar(
          pageName: pageName,
          icon: const Icon(Icons.arrow_back),
          prevContext: context,
        ),

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
                                _selectedGender = _selectedGender;
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


              // Team
              teamDropDown,

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

                    coachDetailsJson = convertEditedCoachDetailsToJson(
                    widget.coachDetailsMap['coach_id'],
                    _fnameController.text, 
                    _lnameController.text, 
                    _selectedGender,
                    _dateController.text.toString(), 
                    _selectedTeam,    
                    _yearGroupController.text,
                    isRetiredInt
                    );

                    // Send the data to the server
                    Map<String, dynamic> response = await editCoach(coachDetailsJson);

                    if (!mounted) return;

                    if (response['status']) {
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
                      showDialog(
                        context: context, 
                        builder: (context) {
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


