import 'dart:convert';
import 'package:apl/helper_classes/grid.dart';
import 'package:apl/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'helper_classes/custom_appbar.dart';
import 'helper_classes/custom_dialog_box.dart';
import 'helper/widgets/text.dart';
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


  @override
  void initState() {
    super.initState();

    getTeams().then((value) {
      setState(() {
        teams = value;
      });
    });
  }

  List<Map<String, dynamic>> teams = [];
  Map <String, dynamic> selectedTeam = {};

  Map <String, dynamic> finalSelectedTeam = {};

  
  @override
  Widget build(BuildContext context) {

    // MyDropdownFormField teamsDropdownFormField = MyDropdownFormField(
    //   items: teamNames,
    //   labelText: "Team Name",
    //   onChanged: (newValue) {
    //     setState(() {
    //       selectedTeam = newValue!;
    //     });
    //   },
    //   validator: (value) {
    //     if (value == null || value.isEmpty) {
    //       return 'Please select a team';
    //     }
    //     return null;
    //   },
                      
    // );

    return MaterialApp(
      home: Scaffold (

        // app bar with back button and page name 
        appBar: CustomAppbar(
          pageName: pageName,
          icon: const Icon(Icons.arrow_back),
          prevContext: context,
        ),

   
        body: Center(
          child: Column(

            // prevent list view from scrolling
            children: [

              // What's your team?
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: const AppText(
                  text: "Select your favourite team",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )
              ),

              Form(
                key: _formKey,
                child: Column(
             
                  children:[
                    
                    TeamSelectionGrid(
                      teams: teams,
                      selectedTeam: selectedTeam,
                      onTeamSelected: (team) {
                        setState(() {
                          selectedTeam = team;
                        });
                      },
                    ),
                    
                    // Continue button
                    SignUpButton(
                      text: 'Finish',
                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          
                          print(selectedTeam['team_id']);

                          Map<String, dynamic> response = await setUserTeam(
                            jsonEncode(<String, dynamic>{
                              'email_address': widget.personalDetailsMap['email_address'],
                              'team_id': selectedTeam['team_id'],
                            })
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

                            // After completing the sign up process, the user is redirected to the sign in page
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => const SignIn(
                                  pageName: 'Sign In',
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
