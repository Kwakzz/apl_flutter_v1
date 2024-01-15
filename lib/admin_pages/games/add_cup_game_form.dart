import 'package:apl/pages/nav_tabs/admin.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/requests/games/add_cup_game_req.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper/widgets/text.dart';
import '../../helper/functions/convert_to_json.dart';


/// This class is the stateful widget where the player can edit their details
class AddCupGameForm extends StatefulWidget {

  const AddCupGameForm(
    {
      super.key, 
      required this.gameweek,
      required this.seasonCompsMap,
      required this.teamsMap,
      required this.stages
    }
  );


  // the gameweek contains the gameweek id which will be a parameter for the add game request
  final Map<String, dynamic> gameweek;

  // for the men's tab, it's only men's competitions for that season
  // for the women's tab, it's only women's competitions for that season
  final List<Map<String, dynamic>> seasonCompsMap;

  // for the women's tab, it's only women's teams
  // for the men's tab, it's only men's teams
  final List<Map<String, dynamic>> teamsMap;

  // for both tabs, it's only the stages for tournaments
  final List<Map<String, dynamic>> stages;
  

  @override
  State<AddCupGameForm> createState() => _AddCupGameFormState();

}

class _AddCupGameFormState extends State<AddCupGameForm> {

  String pageName = 'Add Cup Game';
  final _formKey = GlobalKey<FormState>();

  // game json
  // this will be used to send a request to add a game
  String gameJson = '';

  // selected men's season competition map
  Map<String, dynamic> _selectedSeasonCompMap = {};

  // selected home team map
  Map<String, dynamic> _selectedHomeTeamMap = {};

  // selected away team map
  Map<String, dynamic> _selectedAwayTeamMap = {};

  // selected stage map
  Map<String, dynamic> _selectedStageMap = {};

  // selected time
  TimeOfDay _selectedTime = TimeOfDay.now();

  // time controller
  final _timeController = TextEditingController();

  // select time function 
  // use 24 hour format
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        // set the time controller to the selected time in 24 hour format
        _timeController.text =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00';
      });
    }
  }
  
  @override
  Widget build (BuildContext context) {

    // list of stage names for the dropdown list
    // will be used to display the stage names in the dropdown menu
    final stageNames = widget.stages.map((stage) => stage['stage_name'] as String).toList();

    // dropdown list for stages
    SignUpDropdownFormField stageNamesDropDown = SignUpDropdownFormField(
      items: stageNames,
      labelText: "Stage",
      onChanged: (newValue) {
        setState(() {
          // set selected stage map to the stage map of the selected stage
          // or else return an empty map if the stage is not found
          _selectedStageMap = widget.stages.firstWhere(
            (stage) => stage["stage_name"].toString() == newValue,
            orElse: () => {},
          );
        }
        );
      },
      validator: (value) {
        // Check if stage is empty
        if (value == null || value.isEmpty) {
          return 'Please enter a stage';
        }
        return null;
      },
    );

    // list of season competition names for the dropdown list
    // will be used to display the competition names in the dropdown menu
    final seasonCompsNames = widget.seasonCompsMap.map((seasonComp) => seasonComp['competition_name'] as String).toList();

    // dropdown list for season competitions
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
    SignUpDropdownFormField seasonCompNamesDropDown = SignUpDropdownFormField(
      items: seasonCompsNames,
      labelText: "Competition",
      onChanged: (newValue) {
        setState(() {
          // set selected season competition map to the season competition map of the selected season competition
          // or else return an empty map if the season competition is not found
          _selectedSeasonCompMap = widget.seasonCompsMap.firstWhere(
            (seasonComp) => seasonComp["competition_name"].toString() == newValue,
            orElse: () => {},
          );
        }
        );
      },
      validator: (value) {
        // Check if season competition is empty
        if (value == null || value.isEmpty) {
          return 'Please enter a season competition';
        }
        // check if season competition is "Ashesi Premier League"
        // this form is for only cup games so competition can't be "Ashesi Premier League"
        if (value == "Ashesi Premier League") {
          return 'You can\'t add a cup game for the Ashesi Premier League';
        }
        return null;
      },
    );


    // list of team names for the dropdown list
    // will be used to display the competition names in the dropdown menu
    final teamNames = widget.teamsMap.map((team) => team['team_name'] as String).toList();

    // dropdown list for home team
    SignUpDropdownFormField homeTeamDropdown = SignUpDropdownFormField(
      items: teamNames,
      labelText: "Home team",
      onChanged: (newValue) {
        setState(() {
          // set selected home team map to the team map of the selected team
          // or else return an empty map if the team is not found
          _selectedHomeTeamMap = widget.teamsMap.firstWhere(
            (team) => team["team_name"].toString() == newValue,
            orElse: () => {},
          );
        }
        );
      },
      validator: (value) {
        // Check if home team is empty
        if (value == null || value.isEmpty) {
          return 'Please enter a home team';
        }
         // check if the home team is the same as the away team
        if (_selectedHomeTeamMap["team_name"] == _selectedAwayTeamMap["team_name"]) {
          return 'Home team and away team cannot be the same';
        }
        return null;
      },
      


    );

    // for the away side
    SignUpDropdownFormField awayTeamDropdown = SignUpDropdownFormField(
      items: teamNames,
      labelText: "Away team",
      onChanged: (newValue) {
        setState(() {
          _selectedAwayTeamMap = widget.teamsMap.firstWhere(
            (team) => team["team_name"].toString() == newValue,
            orElse: () => {},
          );
        }
        );
      },
      validator: (value) {
        // Check if away team is empty
        if (value == null || value.isEmpty) {
          return 'Please enter an away team';
        }
        // check if the away team is the same as the home team
        if (_selectedAwayTeamMap["team_name"] == _selectedHomeTeamMap["team_name"]) {
          return 'Home team and away team cannot be the same';
        }
        return null;
      },
    );
    
   
    return Form(
      key: _formKey,
      child: ListView(
        // Children are the form fields
        children: [

          // home team dropdown list
          homeTeamDropdown,

          // away team dropdown list
          awayTeamDropdown,

          // season competition names dropdown list
          seasonCompNamesDropDown,

          // stage names dropdown list
          stageNamesDropDown,

          // Start time
          SignUpTextField(
            controller: _timeController,
            labelText: 'Start Time',
            validator: (value) {
              // Check if start time is empty
              if (value == null || value.isEmpty) {
                return 'Please enter the start time';
              }
              return null;
            },
            keyboardType: TextInputType.datetime,
            onTap: () {
              _selectTime(context);
            },
          ),

          

          // Finish button
          SignUpButton(
            text: "Finish",
            onPressed: () async {
              // Validate the form
              if (_formKey.currentState!.validate()) {   

                // convert game details to json
                gameJson = createCupGameJson(
                  widget.gameweek['gameweek_id'].toString(),
                  _selectedSeasonCompMap['competition_id'].toString(),
                  _selectedHomeTeamMap['team_id'].toString(),
                  _selectedAwayTeamMap['team_id'].toString(),
                  _timeController.text,
                  _selectedStageMap['stage_id'].toString()
                );


                Map<String, dynamic> response = await addCupGame(gameJson);

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
                  
                  Navigator.pushReplacement(
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
    );
  }
}


