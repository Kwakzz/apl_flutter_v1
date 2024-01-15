import 'package:apl/pages/nav_tabs/admin.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:apl/requests/games/edit_game_req.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper/functions/convert_to_json.dart';
import '../../requests/teams/get_teams_req.dart';


/// This class is the stateful widget where the player can edit their details
class EditGameForm extends StatefulWidget {

  EditGameForm(
    {
      Key? key,
      required this.gameDetails,
      required this.seasonCompsMap,
      required this.teamsMap,
    }
  ) : 
  super(
    key: key
  );


  // contains the game details passed from the previous page
  final Map<String, dynamic> gameDetails;

  // if it's the women's tab this will be the women's season comps
  // otherwise, this will be the men's season comps
  final List<Map<String, dynamic>> seasonCompsMap;

  // if it's the women's tab this will be the women's teams
  // otherwise, this will be the men's teams
  List<Map<String, dynamic>> teamsMap;
  

  @override
  State<EditGameForm> createState() => _EditGameFormState();

}

class _EditGameFormState extends State<EditGameForm> {

  String pageName = 'Edit` Game';
  final _formKey = GlobalKey<FormState>();

  // game json
  // this will be used to send a request to add a game
  String gameJson = '';

  // selected men's season competition map
  final Map<String, dynamic> _selectedSeasonCompMap = {};

  // selected home team map
  Map<String, dynamic> _selectedHomeTeamMap = {};

  // selected away team map
  Map<String, dynamic> _selectedAwayTeamMap = {};


  // selected time
  TimeOfDay _selectedTime = TimeOfDay.now();

  // time controller
  late TextEditingController _timeController;

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
  void initState() {
    super.initState();


    // call the function get the men's teams when the page loads
    getTeams().then((result) {
      setState(() {
        widget.teamsMap = result;

        // default selected home team map
        // this is so that the selected home team is the team that is already assigned to the game (in case the user doesn't change it)
        _selectedHomeTeamMap = widget.teamsMap.firstWhere(
          (team) => team["team_id"] == widget.gameDetails['home_id'],
          orElse: () => {}
          );

          // default selected away team map
          _selectedAwayTeamMap = widget.teamsMap.firstWhere(
          (team) => team["team_id"] == widget.gameDetails['away_id'],
          orElse: () => {},
        );
      });
    });

    // default selected time   

    // default selected season competition map
    _selectedSeasonCompMap['competition_id'] = widget.gameDetails['competition_id'];

    // set the time controller to the current time in 24 hour format
    _timeController = TextEditingController(
      text:  '${widget.gameDetails['start_time'].toString().substring(0, 5)}:00',
    );
  }

  
  @override
  Widget build (BuildContext context) {

    // list of season competition names for the dropdown list
    // will be used to display the competition names in the dropdown menu
    final seasonCompsNames = widget.seasonCompsMap.map((seasonComp) => seasonComp['competition_name'] as String).toList();

    final teamNames = widget.teamsMap.map((team) => team['team_name'] as String).toList();

    // dropdown list for season competitions
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
    SignUpDropdownFormField seasonCompNamesDropDown = SignUpDropdownFormField(
      
      items: seasonCompsNames,
      labelText: "Competition",
      onChanged: (newValue) {
        // setState(() {
        //   // set selected season competition map to the season competition map of the selected value
        //   // or else return an empty map if the season competition is not found
        //   _selectedSeasonCompMap = widget.seasonCompsMap.firstWhere(
        //     (seasonComp) => seasonComp["competition_name"] == newValue,
        //     orElse: () => {},
        //   );
        // }
        // );
        null;
      },
      selectedValue: widget.gameDetails['competition_name'],
    );


    // dropdown list for home team
    SignUpDropdownFormField homeTeamDropdown = SignUpDropdownFormField(
      items: teamNames,
      labelText: "Home team",
      onChanged: (newValue) {
        null;
      },
      // selectedValue is the team name whose id matches the id in the game details map.
      // It's the default value
      selectedValue: _selectedHomeTeamMap['team_name'],
    );

    // for the away side
    SignUpDropdownFormField awayTeamDropdown = SignUpDropdownFormField(
      items: teamNames,
      labelText: "Away team",
      onChanged: (newValue) {
        null;
      },
      selectedValue: _selectedAwayTeamMap['team_name'],
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
                gameJson = editGameJson(
                  widget.gameDetails['game_id'],
                  _selectedSeasonCompMap['competition_id'],
                  _selectedHomeTeamMap['team_id'],
                  _selectedAwayTeamMap['team_id'],
                  _timeController.text.toString(),  
                );

                Map <String, dynamic> response = await editGame(gameJson);

                if (!mounted) return;

                if (response['status']) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: AppText(
                        text: 'Game edited successfully', 
                        fontWeight: FontWeight.w300, 
                        fontSize: 12, 
                        color: Colors.white
                      ),
                      duration: Duration(seconds: 2),
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


