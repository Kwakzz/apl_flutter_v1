import 'dart:convert';

import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/user/reset_password_req.dart';
import 'package:flutter/material.dart';
import 'helper_classes/custom_dialog_box.dart';
import 'helper_classes/form_label.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'helper_classes/custom_appbar.dart';
import 'helper_classes/sign_in_field.dart';

class ForgotPassword extends StatefulWidget {

  const ForgotPassword(
    {
      super.key, 
      required this.pageName
    }
  );
  final String pageName;
  

  @override
  State<ForgotPassword> createState() => _SignInState();

}

class _SignInState extends State<ForgotPassword> {
  String pageName = 'Forgot Password';
  final _formKey = GlobalKey<FormState>();


  // controllers for the text fields
  final TextEditingController _emailController = TextEditingController();

  
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

   
        body: Form(
          key: _formKey,
          child: ListView(

            children: [

              // Confirm email address
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: const AppText(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  text: 'Confirm your email address',
                )
              ),

              // Enter the email address associated with your account
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                alignment: Alignment.center,
                child: const AppText(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  text: 'Forgotten your password? Enter the email address associated with your account and we\'ll email you a link to reset your password.',
                )
              ),


              // Email address field
              const SignInFormLabel(labelText: 'Email Address'),
              SignInTextField(
                labelText: 'Email Address',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),


              // Sign in button
              GenericFormButton(
                text: 'Reset my password',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    
                    String emailJson =  jsonEncode(
                      <String, dynamic>
                      {
                        'email_address': _emailController.text,
                      }
                    );

                      Map<String, dynamic> response = await resetPassword(emailJson);

                      if (!mounted) return;

                      if (response['status']) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialogueBox(
                              text: 'Password Reset',
                              content: response['message'],
                            );
                          }
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialogueBox(
                              text: 'Password Reset Error',
                              content: response['message'],
                            );
                          }
                        );
                      }
    
                  }
                },
              ),

            ],
          ) 
        ),

        backgroundColor: Colors.white,
      )
    );
  }
}
