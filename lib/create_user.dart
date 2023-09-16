import 'dart:convert';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/requests/user/sign_up_req.dart';
import 'package:flutter/material.dart';
import 'package:apl/email_activation.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../helper_classes/custom_button.dart';
import '../helper_classes/signup_field.dart';
import 'helper_classes/custom_appbar.dart';
import 'helper_classes/radio_form_field.dart';
import 'helper_functions/valid_phone_number.dart';
import 'helper_functions/valid_email.dart';
import 'helper_functions/convert_to_json.dart';
import 'helper_functions/valid_password.dart';


/// This class is the stateful widget where the user fills in their personal details
/// to create an account.
class CreateUser extends StatefulWidget {

  const CreateUser({super.key, required this.pageName});
  final String pageName;

  @override
  State<CreateUser> createState() => _CreateUserState();

}

class _CreateUserState extends State<CreateUser> {
  String pageName = 'Personal Details';
  final _formKey = GlobalKey<FormState>();

  // Date of birth
  DateTime? _selectedDate;

  // Controllers for the text fields
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedGender = "Male";
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
  Widget build(BuildContext context) {
   
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
                keyboardType: TextInputType.emailAddress,
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

              // Continue button
              SignUpButton(
                text: "Continue",
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {
                    personalDetailsJson = convertPersonalDetailsToJson(
                    _fnameController.text, 
                    _lnameController.text, 
                    _emailController.text, 
                    _passwordController.text,
                    _selectedGender, 
                    _dateController.text.toString(), 
                    _mobileController.text
                    );

                    Map<String, dynamic> response = await submitNewUserData(personalDetailsJson);

                    if(!mounted) return;

                    if (response['status']) {
                      // Create map of personal details
                      personalDetailsMap = jsonDecode(personalDetailsJson);
                      // Navigate to the next screen
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => EmailActivation(
                            personalDetailsMap: personalDetailsMap,
                          ),
                        ),
                      ); 
                    }
                    
                    else {

                      // show alert of error
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

