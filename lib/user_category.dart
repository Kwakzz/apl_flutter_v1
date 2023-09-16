import 'dart:convert';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'helper_classes/custom_appbar.dart';
import 'helper_classes/text.dart';
import 'requests/user/player_or_coach_registration_req.dart';



class UserCategory extends StatefulWidget {

  const UserCategory(
    {
    super.key, 
    required this.pageName,
    required this.personalDetailsMap
    }
  );

  final String pageName;

  // user's details from previous screen
  final Map <String, dynamic> personalDetailsMap;
  

  @override
  State<UserCategory> createState() => _UserCategoryState();

}

class _UserCategoryState extends State<UserCategory> {

  // form key
  final _formKey = GlobalKey<FormState>();

  String pageName = 'User Category';

  String userCategory = "";

  


  
  @override
  Widget build(BuildContext context) {

    MyDropdownFormField userCategoryDropdownField = MyDropdownFormField(
      items: const ["Fan", "Player", "Coach"],
      labelText: "User category",
      onChanged: (newValue) {
        setState(() {
          userCategory = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a user category';
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

        // sign in form.
        // It contains the following fields:
        // - Email address
        // - Password
   
        body: Center(

          child : Form(
            key: _formKey,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // User Category dropdown
                userCategoryDropdownField,
                
                // Finish button
                SignInButton(
                  text: 'Finish',
                  onPressed: () async {

                    if (_formKey.currentState!.validate()) {
                     

                      // IF USER SELECTS 'PLAYER'
                      if (userCategory == "Player") {

                        Map <String, dynamic> response = await registerUserAsPlayer(
                          jsonEncode(
                            widget.personalDetailsMap
                          )
                        );


                        if (response['status']) {

                          if (!mounted) return;

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

                          // Navigate to Sign in screen
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const SignIn(
                                pageName: 'Sign In', 
                              ),
                            ),
                          );

                        }
                      }

                      // IF USER SELECTS 'COACH'
                        else if (userCategory == "Coach") {
                        
                          Map<String, dynamic> response = await registerUserAsCoach(
                            jsonEncode(
                              widget.personalDetailsMap
                            )
                          );

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

                            // Navigate to Sign in screen
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => const SignIn(
                                  pageName: 'Sign In', 
                                ),
                              ),
                            );

                          }     
      
                        }

                        // IF USER SELECTS 'FAN'
                        // NAVIGATE TO SIGN IN SCREEN
                        else {

                          if (!mounted) return;

                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const SignIn(
                                pageName: 'Sign In'
                              ),
                            ),
                          );
                        }

                      
                    }
                  }
                )



              ],
            ) 
          )
        ),

        backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      )
    );
  }
}
