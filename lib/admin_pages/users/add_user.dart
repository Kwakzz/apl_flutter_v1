import 'package:apl/admin.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/radio_form_field.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper_classes/text.dart';
import '../../helper_functions/valid_phone_number.dart';
import '../../helper_functions/valid_email.dart';
import '../../helper_functions/convert_to_json.dart';
import '../../helper_functions/valid_password.dart';
import '../../requests/admin/add_user_req.dart';
import '../../requests/teams/get_teams_req.dart';


/// This class is the stateful widget where the user fills in their personal details
/// to create an account.
class AddFan extends StatefulWidget {

  const AddFan({super.key, required this.pageName});
  final String pageName;

  @override
  State<AddFan> createState() => _AddFanState();

}

class _AddFanState extends State<AddFan> {
  String pageName = 'Add User';
  final _formKey = GlobalKey<FormState>();

  // Teams for drop down list
  List<String> teamNames = [];

  // Date of birth
  DateTime? _selectedDate;

  // Controllers for the text fields
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedGender = "Male";
  String _isAdmin = "Regular";
  late String _selectedTeam ;
  final _dateController = TextEditingController();
  final _mobileController = TextEditingController();

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
  /// Dispose of the controllers when the widget is removed from the tree
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    _mobileController.dispose();
    super.dispose();
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

  }

  
  @override
  Widget build(BuildContext context) {

    // dropdown list for teams
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
    SignUpDropdownFormField teamDropDown = 
    SignUpDropdownFormField(
      items: teamNames,
      labelText: "Your favourite team",
      onChanged: (newValue) {
        setState(() {
          _selectedTeam = newValue!;
        }
        );
      }
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
              ),

              // Password
              SignUpPasswordField(
                controller: _passwordController,
                labelText: 'Password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (!validatePassword(value)) {
                    return 'Password must contain at least 8 characters,\n1 uppercase letter, 1 lowercase letter, 1 number\nand 1 special character';
                  }
                  return null;
                },
              ),

              // Confirm password
              SignUpPasswordField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                validator: (value) {
                  if (value == null || value.isEmpty ) {
                    return 'Please enter your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
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

              teamDropDown,
              
            
              // User Type
              RadioFormField(
                labelText: "User Type", 
                firstValue: "Regular", 
                secondValue: "Admin", 
                selectedValue: _isAdmin, 
                onChanged: (value) {
                              setState(() {
                                _isAdmin = value!;
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

                    // convert is_admin to int
                    int isAdminInt = 0;

                    if (_isAdmin == "Admin") {
                      isAdminInt = 1;
                    }                    

                    personalDetailsJson = convertNewFanDetailsToJson(
                    _fnameController.text, 
                    _lnameController.text, 
                    _emailController.text, 
                    _passwordController.text,
                    _selectedGender, 
                    _dateController.text.toString(), 
                    _mobileController.text,
                    _selectedTeam,
                    isAdminInt
                    );

                    Map <String, dynamic> response = await addUser(personalDetailsJson);

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
                          builder: (context) => Admin(pageName: pageName),
                        ),
                      );
                    }
                    
                    else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialogueBox(
                            content: response['message']
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

