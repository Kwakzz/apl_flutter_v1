import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:apl/helper/functions/convert_to_json.dart';
import 'package:apl/requests/starting_xi/add_starting_xi_req.dart';
import 'package:apl/requests/starting_xi/get_team_starting_xi_players_req.dart';
import 'package:apl/requests/starting_xi/get_team_starting_xi_req.dart';
import 'package:apl/requests/teams/get_team_players_req.dart';
import 'package:flutter/material.dart';

import '../../requests/positions/get_positions_req.dart';
import '../../requests/starting_xi/add_starting_xi_player_req.dart';



class TeamLineup extends StatefulWidget {
  const TeamLineup(
    {
      super.key,
      required this.game,
      required this.team,
    }
  );

  final Map<String, dynamic> game;
  final Map<dynamic, dynamic> team;

  @override
  _TeamLineupState createState() => _TeamLineupState();
}

class _TeamLineupState extends State<TeamLineup> {

  // dialog box form key
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> malePlayers = [];
  List<Map<String, dynamic>> femalePlayers = [];

  Map<String, dynamic> selectedPlayerMap = {};
  Map<String, dynamic> selectedPosition = {};

  List<Map<String, dynamic>> dropdownPlayersMap = [];
  List<String> dropDownListForPlayers = [];

  List<Map<String, dynamic>> dropdownPositionsMap = [];
  List<String> dropDownListForPositions = [];

  Map<String, dynamic> teamStartingXI = {};
  List <Map<String, dynamic>> teamStartingXIPlayers = [];

  // group starting xi by position
  List <Map<String, dynamic>> goalkeepers = [];
  List <Map<String, dynamic>> defenders = [];
  List <Map<String, dynamic>> midfielders = [];
  List <Map<String, dynamic>> forwards = [];

  

  @override
  void initState() {
    super.initState();

    getTeamStartingXI(widget.game['game_id'], widget.team['team_id']).then((result) {
      setState(() {
        teamStartingXI = result;

        try {
          // get the list of players in the starting XI
          getTeamStartingXIPlayers(teamStartingXI['xi_id']).then((result) {
            setState(() {
              teamStartingXIPlayers = result;

              // group players by position
              goalkeepers = teamStartingXIPlayers.where((player) => player['position_name'] == 'Goalkeeper').toList();
              defenders = teamStartingXIPlayers.where((player) => player['position_name'] == 'Defender').toList();
              midfielders = teamStartingXIPlayers.where((player) => player['position_name'] == 'Midfielder').toList();
              forwards = teamStartingXIPlayers.where((player) => player['position_name'] == 'Forward').toList();

            });
          });
        }
        catch (e) {
          return;
        }

      });

    });

    // get the list of players in the team
    getActiveMensTeamPlayers(widget.team['team_id']).then((result) {
      setState(() {
        malePlayers = result;
      });
    });

    getActiveWomensTeamPlayers(widget.team['team_id']).then((result) {
      setState(() {
        femalePlayers = result;
      });
    });

    // get all positions
    getPositions().then((result) {
      setState(() {
        dropdownPositionsMap = result;
        dropDownListForPositions = dropdownPositionsMap.map((position) => position['position_name'] as String).toList();
      });
    });

  }

  /// Refreshes the data on the page
  void refreshData () {
    getTeamStartingXIPlayers(teamStartingXI['xi_id']).then((result) {
      setState(() {
        teamStartingXIPlayers = result;

        // Group players by position
        goalkeepers = teamStartingXIPlayers.where((player) => player['position_name'] == 'Goalkeeper').toList();
        defenders = teamStartingXIPlayers.where((player) => player['position_name'] == 'Defender').toList();
        midfielders = teamStartingXIPlayers.where((player) => player['position_name'] == 'Midfielder').toList();
        forwards = teamStartingXIPlayers.where((player) => player['position_name'] == 'Forward').toList();
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    // Calculate the height of the ListView dynamically based on the number of items

    double goalkeeperListViewHeight = goalkeepers.length * 56.0; 
    double defenderListViewHeight = defenders.length * 56.0; 
    double midfielderListViewHeight = midfielders.length * 56.0; 
    double forwardListViewHeight = forwards.length * 56.0; 

    // Create a list of player IDs in the starting XI
    List<int> startingXIPlayerIds = teamStartingXIPlayers.map<int>((player) => player['player_id']).toList();

    if (widget.game['gender'] == "Female") {
      dropdownPlayersMap = femalePlayers;
      // use player names for dropdown
      // exclude players that are already in the starting XI
      // if there's a map with a player id that equals a player id in the starting XI, exclude it
      dropDownListForPlayers = dropdownPlayersMap
      .where((player) => !startingXIPlayerIds.contains(player['player_id']))
      .map((player) => '${player['fname']} ${player['lname']}')
      .toList();
    }
    else {
      dropdownPlayersMap = malePlayers;
      dropDownListForPlayers = dropdownPlayersMap
      .where((player) => !startingXIPlayerIds.contains(player['player_id']))
      .map((player) => '${player['fname']} ${player['lname']}')
      .toList();
    }

    

    // if the starting XI is empty, return "No Starting XI"
    if (teamStartingXI.isEmpty) {

      return Column(
          children: [

             // add starting xi button
            SmallAddButton(
              onPressed: () async {


                // adding a starting XI will allow you to add a player
                Map<String, dynamic> response = await addStartingXI(
                  createStartingXIJson(
                    widget.game['game_id'],
                    widget.team['team_id']
                  )
                );

                if (!mounted) return;

                if (response['status']) {
                  // refresh the page so that the admin can start adding players
                  getTeamStartingXI(widget.game['game_id'], widget.team['team_id']).then((result) {
                    setState(() {
                      teamStartingXI = result;
                    }
                    );
                  });
                }

                else {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return ErrorDialogueBox(
                        content: response['message'],
                      );
                    }
                  );
                }
              },

              text: "Add Starting XI"
            ),

            const AppText(
              text: 'No Starting XI',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),

          ]
      );
    }

    // prevent the page from crashing if the formation hasn't been loaded yet
    
    
      return ListView(

          children: [
    
            SmallAddButton(
              onPressed: () {
                // if the starting XI has 11 players, don't allow any more players to be added
                if (teamStartingXIPlayers.length == 11) {
                  return;
                }

                else {

                  showDialog(
                    context: context, 
                    builder: (context) {
                      return AddPlayerToStartingXIDialogBox(
                        players: dropDownListForPlayers, 
                        positions: dropDownListForPositions, 
                        playerDropDownOnChanged: (newValue) {
                          setState(() {
                            selectedPlayerMap = dropdownPlayersMap.firstWhere(
                              (player) => '${player['fname']} ${player['lname']}' == newValue,
                              orElse: () => {},
                            );
                          
                          });
                        }, 
                        positionDropDownOnChanged:  (newValue) {
                          setState(() {
                            selectedPosition = dropdownPositionsMap.firstWhere(
                              (position) => position['position_name'] == newValue,
                              orElse: () => {},
                            );
                          });
                        }, 
                        submitButtonOnPressed: () async {
                          // add player to starting XI
                          Map<String, dynamic> response = await addStartingXIPlayer(
                            startingXIPlayerJson(
                              teamStartingXI['xi_id'],
                              selectedPlayerMap['player_id'],
                              selectedPosition['position_id']
                            )
                          );

                          if (!mounted) return;

                          if (response['status']) {
                                                       // refresh data
                            refreshData();
                              
                          }

                          else {
                            showDialog(
                              context: Scaffold.of(context).context, 
                              builder: (context) {
                                return ErrorDialogueBox(
                                  content: response['message'],
                                );
                              }
                            );
                          }                        
                        }, 
                        positionValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose a position';
                          }
                          // if there's already  a goalkeeper in the starting XI, don't allow another goalkeeper to be added
                          if (value == 'Goalkeeper' && goalkeepers.length == 1) {
                            return 'There is already a goalkeeper in the starting XI';
                          }
                          return null;
                        },
                        formKey: _formKey
                      );
                    }
                  );

                }

              },
              text: "Add Player"
            ),

            // Goalkeeper
            const ListTile(
              title: AppText(
                text: "Goalkeeper",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),
            ),
            
            StartingXISection(
              height: goalkeeperListViewHeight, 
              players: goalkeepers, 
              teamStartingXI: teamStartingXI, 
              refreshData: refreshData
            ),

            // Defenders
            const ListTile(
              title: AppText(
                text: "Defenders",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),
            ),

           StartingXISection(
              height: defenderListViewHeight, 
              players: defenders, 
              teamStartingXI: teamStartingXI, 
              refreshData: refreshData
            ),
                  
            
            // Midfielders
            const ListTile(
              title: AppText(
                text: "Midfielders",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),
            ),

            StartingXISection(
              height: midfielderListViewHeight, 
              players: midfielders, 
              teamStartingXI: teamStartingXI, 
              refreshData: refreshData
            ),

            // Forwards
            const ListTile(
              title: AppText(
                text: "Forwards",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),
            ),

            StartingXISection(
              height: forwardListViewHeight, 
              players: forwards, 
              teamStartingXI: teamStartingXI, 
              refreshData: refreshData
            ),
          ]
      );
   
  }
}