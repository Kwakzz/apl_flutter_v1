import 'dart:convert';

import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/user_category.dart';
import 'package:flutter/material.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'helper_classes/custom_appbar.dart';
import 'helper_classes/custom_dialog_box.dart';
import 'helper_classes/text.dart';
import 'requests/user/set_team_req.dart';
import 'requests/teams/get_teams_req.dart';


class SelectTeam extends StatefulWidget {

  const SelectTeam(
    {
    super.key, 
    required this.pageName,
    required this.personalDetailsMap,
    }
  );

  final String pageName;

   // user's details from previous screen
  final Map <String, dynamic> personalDetailsMap;


  @override
  State<SelectTeam> createState() => _SelectTeamState();

}

class _SelectTeamState extends State<SelectTeam> {
  String pageName = 'Select Team';

  // form key
  final _formKey = GlobalKey<FormState>();

  List<String> teamNames = [];
  String selectedTeam = "";

  @override
  void initState() {
    super.initState();
    getTeamNames().then((names) {
      setState(() {
        teamNames = names;
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {

    MyDropdownFormField teamsDropdownFormField = MyDropdownFormField(
      items: teamNames,
      labelText: "Team Name",
      onChanged: (newValue) {
        setState(() {
          selectedTeam = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
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

        // sign in form.
        // It contains the following fields:
        // - Email address
        // - Password
   
        body: Center(
          child: ListView(

            // prevent list view from scrolling
            physics: const NeverScrollableScrollPhysics(),
            children: [

              // What's your team?
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: const AppText(
                  text: "What's your team?",
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                )
              ),

              Form(
                key: _formKey,
                child: Column(
             
                  children:[
                    
                    teamsDropdownFormField,
                    
                    // Continue button
                    SignUpButton(
                      text: 'Continue',
                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          

                          // Add the user's team to the personal details map
                          widget.personalDetailsMap['team_name'] = selectedTeam;

                          Map<String, dynamic> response = await setUserTeam(jsonEncode(widget.personalDetailsMap));
                          
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

                            // After completing the sign up process, the user is redirected to the sign in page
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => UserCategory(
                                  pageName: 'User Category',
                                  personalDetailsMap: widget.personalDetailsMap,
                                )
                              )
                            );
                          } 
                          
                          else {
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
            ]
          )
        ),
        backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      )
    );
  }
}
