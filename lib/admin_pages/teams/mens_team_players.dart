import 'dart:convert';

import 'package:apl/admin_pages/players/edit_player.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/helper_functions/convert_to_json.dart';
import 'package:apl/requests/teams/get_teams_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/custom_dropdown.dart';
import '../../requests/teams/get_team_players_req.dart';
import '../../requests/positions/get_positions_req.dart';
import '../../requests/players/delete_player_req.dart';
import '../../helper_classes/search_field.dart';
import '../../requests/transfers/add_transfer_req.dart';


class MensTeamPlayers extends StatefulWidget {
  const MensTeamPlayers(
    {
      super.key,
      required this.team,
    }
  );

  // The map of the team
  final Map<String, dynamic> team;

  @override
  _MensTeamPlayersState createState() => _MensTeamPlayersState();
}

class _MensTeamPlayersState extends State<MensTeamPlayers> {

  // form key
  final formKey = GlobalKey<FormState>();

  List <Map<String, dynamic>> teams = [];


  List<Map<String, dynamic>> teamPlayers = [];
  List<Map<String, dynamic>> positions = [];

  // selected criteria
  String selectedCriteria = "Active";

  // selected team map
  Map<String, dynamic> _selectedTeamMap = {};

  // selected transfer type
  String _selectedTransferType = "Permanent";

  String transferJson = "";



  @override
  /// This function is called when the page loads.
  /// It calls the function to get the teams.
  /// It also sets the filteredTeams list to the teams list.
  void initState() {
    super.initState();

    // Call the function to get the teams when the page loads
    getActiveMensTeamPlayers(widget.team['team_id']).then((result) {
      setState(() {
        teamPlayers = result;
        filteredTeamPlayers = teamPlayers;
      });
    });

    // Call the function to get the positions when the page loads
    // This is used to display the position name instead of the position id
    getPositions().then((result) {
      setState(() {
        positions = result;
      });
    });

    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

  }

  String searchQuery = '';

  // list of players for the search bar
  List<Map<String, dynamic>> filteredTeamPlayers = [];

  /// This function is called when the search bar is used.
  void updateFilteredPlayers(String query) {
    filteredTeamPlayers = teamPlayers.where((player) {
      final fullName = '${player['fname']} ${player['lname']}'.toLowerCase();
      // return the full names that contain the query
      return fullName.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    List <String> playerCriteria = ["Active", "Retired"];

    MyDropdownFormField playerCriteriaDropDown = MyDropdownFormField(
      items: playerCriteria,
      selectedValue: selectedCriteria,
      labelText: "Player Criteria",
      onChanged: (newValue) {

        setState(() {
          selectedCriteria = newValue!;

          if (newValue == "Active") {
            getActiveMensTeamPlayers(widget.team['team_id']).then((result) {
              setState(() {
                teamPlayers = result;
                filteredTeamPlayers = teamPlayers;
              });
            });

          } 

          if (newValue == "Retired") {
            getRetiredMensTeamPlayers(widget.team['team_id']).then((result) {
              setState(() {
                teamPlayers = result;
                filteredTeamPlayers = teamPlayers;
              });
            });
          }

        });
      }
        
    );
    
    // if the list of players is empty, return "No players found"
    if (teamPlayers.isEmpty) {

      return Column(
        children : [

          playerCriteriaDropDown,
          
          const AppText(
            text: 'No players found',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            
          ),
        ]
      );
    }

    return Column(
        children: [
          // Player criteria dropdown
          playerCriteriaDropDown,

          // Search bar
          SearchField(
            onChanged: (value) {
              setState(() {
                searchQuery = value!;
                updateFilteredPlayers(searchQuery);
              });
            },
            labelText: 'Search by name',
          ),

     
          // List of players in the team
          Expanded(
            child: ListView.builder(
              itemCount: filteredTeamPlayers.length,
              itemBuilder: (context, index) {
                final teamPlayer = filteredTeamPlayers[index];
                final team = teams.firstWhere(
                  (team) => team['team_id'] == teamPlayer['team_id'],
                  orElse: () => {'team_name': "None"},
                );
                final position = positions.firstWhere(
                  (position) => position['position_id'] == teamPlayer['position_id'],
                  orElse: () => {'position_name': "None"}, 
                );

                // team dropdown list without the current team
                List <String> teamDropDownList = teams.map((team) => team['team_name'].toString()).toList();
                teamDropDownList.remove(team['team_name']);
                

                return PlayerAdminListTile(
                  title: '${teamPlayer['fname']} ${teamPlayer['lname']}',
                  subtitle: '${position['position_name']}',
                  editOnTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => EditPlayer(
                          pageName: 'Edit Player',
                          playerDetailsMap: jsonDecode(
                            convertEditedPlayerDetailsToJson(
                              teamPlayer['player_id'],
                              teamPlayer['fname'], 
                              teamPlayer['lname'], 
                              teamPlayer['gender'], 
                              teamPlayer['date_of_birth'], 
                              position['position_name'], 
                              widget.team['team_name'],
                              teamPlayer['height'],
                              teamPlayer['weight'], 
                              teamPlayer['year_group'], 
                              teamPlayer['is_retired']
                            )
                          ),
                        )
                      ),
                    );  
                  }, 
                  deleteOnTap: () {
                     showDialog(
                        context: context, 
                        builder: (context) {
                          return DeleteConfirmationDialogBox(
                            title: "Delete Player", 
                            content: "Are you sure you want to delete this player?", 
                            onPressed: () async {

                              Map <String, dynamic> response = await deletePlayer(
                                jsonEncode( {
                                  'player_id': teamPlayer['player_id']
                                }
                                )
                              );

                              if (!mounted) return;

                              if (response['status']) {

                                showDialog(
                                  context: context, 
                                  builder: (context) {
                                    return ErrorDialogueBox(
                                      content: response['message'], 
                                      text: "Success",
                                    );
                                  }
                                );
                                // refresh the page
                                setState(() {
                                  teamPlayers.removeAt(index);
                                });
                                
                              } else {
                                showDialog(
                                  context: context, 
                                  builder: (context) {
                                    return ErrorDialogueBox(
                                      content: response['message'], 
                                    );
                                  }
                                );
                              }
                            }
                              
                          );
                        }
                      );

                    },

                    changeClubOnTap: () {

                      showDialog(
                        // specify the root widget's context. This determines where the dialogue box will be displayed on the screen
                        context: context, 
                        builder: (context) {
                        // this context is used to close the dialogue box.
                        return TransferDialogueBox(
                          teamDropDownList: teamDropDownList, teamValidator: (value) {
                            if (value == null) {
                              return "Please select a team";
                            }
                            return null;
                          }, 
                          transferTypeValidator: (value) {
                            if (value == null) {
                              return "Please select a transfer type";
                            }
                            return null;
                          },
                          formKey: formKey, 
                          submitButtonOnPressed: () async {

                            if (formKey.currentState!.validate()) {
                
                              transferJson = transferPlayerJson(
                                teamPlayer['player_id'],
                                teamPlayer['team_id'], 
                                _selectedTeamMap['team_id'],
                                DateTime.now().toString().substring(0, 10), 
                                _selectedTransferType
                              );

                              Map <String, dynamic> response = await addTransfer(transferJson);

                              if (!mounted) return;

                              if (response['status']) {

                                // show success dialogue box
                                showDialog(
                                  // use root widget's context, not the dialogue box's context
                                  context: context, 
                                  builder: (BuildContext context) {
                                    return ErrorDialogueBox(
                                      content: response['message'], 
                                      text: "Success",
                                    );
                                  }
                                );

                                // refresh the page
                                setState(() {
                                  teamPlayers.removeAt(index);
                                });
                                
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
                          teamDropDownOnChanged: (value) {
                             setState(() {
                              _selectedTeamMap = teams.firstWhere(
                                (t) => t["team_name"].toString() == value,
                                orElse: () => {},
                              );
                            });
                          }, 
                          transferTypeOnChanged: (value) {
                            setState(() {
                              _selectedTransferType = value!; 
                            });
                          },
                        );   
                      }
                    );
                  }
                  
                );
              },
            )
          ),

        ]
    );
  }
}