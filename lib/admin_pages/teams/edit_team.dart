import 'package:apl/pages/nav_tabs/admin.dart';
import 'package:apl/requests/teams/edit_team_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper/widgets/text.dart';
import '../../helper/functions/convert_to_json.dart';


class EditTeam extends StatefulWidget {

  const EditTeam(
    {
      super.key, 
      required this.pageName,
      required this.team
    }
  );

  final String pageName;
  
  // map of the team's details
  final Map<String, dynamic> team;
  

  @override
  State<EditTeam> createState() => _EditTeamState();

}

class _EditTeamState extends State<EditTeam> {

  String pageName = 'Edit Team';
  final _formKey = GlobalKey<FormState>();


  // Controllers for the text fields
  late TextEditingController _teamNameController;
  late TextEditingController _teamAbbrevController;
  late TextEditingController _teamLogoURLController;


  // Team's details
  String teamDetailsJson = '';


  @override
  /// Dispose of the controllers when the widget is removed from the tree
  void dispose() {
    _teamNameController.dispose();
    _teamAbbrevController.dispose();
    _teamLogoURLController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController(text: widget.team['team_name']);
    _teamAbbrevController = TextEditingController(text: widget.team['team_name_abbrev']);
    _teamLogoURLController = TextEditingController(text: widget.team['team_logo_url']);
  }

  
  @override
  Widget build (BuildContext context) {
 
    return MaterialApp(
      home: Scaffold (

        // app bar with back button and page name 
        appBar: CustomAppbar(
          pageName: pageName,
          icon: const Icon(Icons.arrow_back),
          prevContext: context,
        ),


        // edit team form.
        // It contains the following fields:
        // - team name
        // - team abbreviation
        // - team logo (not implemented yet)

        body: Form(
          key: _formKey,
          child: ListView(
            // Children are the form fields
            children: [

              // Team name
              SignUpTextField(
                controller: _teamNameController,
                labelText: 'First Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your the team name';
                  }
                  return null;
                },
              ),

              // Team name abbrev
              SignUpTextField(
                controller: _teamAbbrevController,
                labelText: 'Team Name Abbreviation',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the team name abbreviation";
                  }
                  return null;
                },
              ),            


              // Continue button
              SignUpButton(
                text: "Finish",
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {

                    teamDetailsJson = convertTeamDetailsToJson(
                    _teamNameController.text, 
                    _teamAbbrevController.text,
                    );
                

                    // Send the data to the server
                    Map<String, dynamic> response = await editTeam(teamDetailsJson);

                    if(!mounted) return;

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
                      // Display an error message
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


