import 'package:apl/admin.dart';
import 'package:apl/helper_classes/radio_form_field.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/requests/admin/edit_user_req.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper_classes/text.dart';
import '../../helper_functions/valid_phone_number.dart';
import '../../helper_functions/valid_email.dart';
import '../../helper_functions/convert_to_json.dart';
import '../../requests/teams/get_teams_req.dart';


/// This class is the stateful widget where the user can edit their details
class EditUser extends StatefulWidget {

  const EditUser(
    {
      super.key, 
      required this.pageName,
      required this.personalDetailsMap
    }
  );

  final String pageName;
  // User's details
  final Map <String, dynamic> personalDetailsMap;
  

  @override
  State<EditUser> createState() => _EditUserState();

}

class _EditUserState extends State<EditUser> {
  String pageName = 'Edit User';
  final _formKey = GlobalKey<FormState>();

  // Date of birth
  DateTime? _selectedDate;

  // Teams for drop down list
  List<String> teamNames = [];

  // Controllers for the text fields
  // They are initialized with the user's values
  // so that the admin can edit them. Gender and 
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  late TextEditingController _emailController;
  late String _selectedGender;
  late String _selectedTeam;
  late String _isAdmin;
  late String _isActive;
  late TextEditingController _dateController;
  late TextEditingController _mobileController;

  // User's details
  Map <String, dynamic> personalDetailsMap = {};
  String personalDetailsJson = '';


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

    _fnameController = TextEditingController(
      text: widget.personalDetailsMap['fname']
      );
    _lnameController = TextEditingController(
      text: widget.personalDetailsMap['lname']
    );
    _emailController = TextEditingController(
      text: widget.personalDetailsMap['email_address']
    );
    _mobileController = TextEditingController(
      text: widget.personalDetailsMap['mobile_number']
    );
    _selectedGender = widget.personalDetailsMap['gender'];

    if (widget.personalDetailsMap['team_name'] == null) {

      setState(() {
        teamNames.add("None");
        _selectedTeam = widget.personalDetailsMap['team_name'];
      });
      
    } else {
      _selectedTeam = widget.personalDetailsMap['team_name'];
    }

    _dateController = TextEditingController(
      text: widget.personalDetailsMap['date_of_birth']
    );
    if (widget.personalDetailsMap['is_admin'] == 1) {
      _isAdmin = 'Admin';
    } else {
      _isAdmin = 'Regular';
    }
    if (widget.personalDetailsMap['is_active'] == 1) {
      _isActive = 'Active';
    } else {
      _isActive = 'Inactive';
    }

  }


  @override
  /// Dispose of the controllers when the widget is removed from the tree
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {

    // dropdown list for teams
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
    SignUpDropdownFormField teamDropDown = 
    SignUpDropdownFormField(
      items: teamNames,
      labelText: "Your Team",
      onChanged: (newValue) {
        setState(() {
          _selectedTeam = newValue!;
        }
        );
      },
      selectedValue: _selectedTeam,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a team';
        }
        if (value == "None") {
          return 'Please select a team';
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


        // sign up form.
        // It contains the following fields:
        // - First name
        // - Last name
        // - Email address
        // - Password
        // - Confirm password
        // - Gender
        // - Date of birth
        // - Mobile Number
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

              // Email address
              SignUpTextField(
                controller: _emailController,
                labelText: 'Email Address',
                validator: (value) {
                  // Check if email is empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  // Check if email matches the email regex
                  if (!isEmailValid(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                enabled: false,
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
                  });
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

              // mobile number
              SignUpTextField(
                controller: _mobileController,
                labelText: 'Mobile Number',
                validator: (value) {
                  // Check if mobile number is empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  // Check if mobile number matches the mobile number regex
                  if (!isValidPhoneNumber(value)) {
                    return 'Please enter a valid mobile number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
               
              ),

              // Team
              teamDropDown,
              

              // Status
              RadioFormField(
                labelText: "Status", 
                firstValue: "Active", 
                secondValue: "Inactive", 
                selectedValue: _isActive, 
                onChanged: (value) {
                  setState(() {
                    _isActive = value!;
                  });
                },
              ),

              // User Type
              RadioFormField(
                labelText: "User Type", 
                firstValue: "Regular", 
                secondValue: "Admin", 
                selectedValue: _isAdmin, 
                onChanged: (value) {
                  setState(() {
                    _isAdmin = value!;
                  });
                },
              ),

              // Continue button
              SignUpButton(
                text: "Finish",
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {

                    // convert is_active and is_admin to int
                    int isActiveInt = 0;
                    int isAdminInt = 0;

                    if (_isActive == "Active") {
                      isActiveInt = 1;
                    }

                    if (_isAdmin == "Admin") {
                      isAdminInt = 1;
                    }                    

                    personalDetailsJson = convertEditedFanDetailsToJson(
                    widget.personalDetailsMap['user_id'],
                    _fnameController.text, 
                    _lnameController.text, 
                    _dateController.text.toString(), 
                    _mobileController.text,
                    _selectedTeam,
                    isAdminInt,
                    isActiveInt
                    );

                    Map<String, dynamic> response = await editUser(personalDetailsJson);

                    if (!mounted) return;

                    if (response['status']) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor:const Color.fromARGB(255, 28, 28, 28),
                          content: AppText(
                            text: response['message'],
                            fontWeight: FontWeight.w300, 
                            fontSize: 12, 
                            color: Colors.white
                          ),
                          duration:const Duration(seconds: 2),
                        ),
                      );

                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => 
                          const Admin(
                            pageName: 'Admin',
                          )
                        )
                      );
                    } else {
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

