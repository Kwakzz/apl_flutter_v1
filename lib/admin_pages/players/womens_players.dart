import 'dart:convert';

import 'package:apl/admin_pages/players/add_player.dart';
import 'package:apl/admin_pages/players/edit_player.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/error_handling.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/helper_functions/convert_to_json.dart';
import 'package:apl/requests/players/get_womens_players_req.dart';
import 'package:apl/requests/teams/get_womens_teams_req.dart';
import 'package:apl/requests/transfers/add_transfer_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/custom_dropdown.dart';
import '../../helper_classes/custom_list_tile.dart';
import '../../requests/players/delete_player_req.dart';
import '../../requests/positions/get_positions_req.dart';
import '../../helper_classes/search_field.dart';


class WomensPlayers extends StatefulWidget {
  const WomensPlayers({super.key});

  @override
  _WomensPlayersState createState() => _WomensPlayersState();
}

class _WomensPlayersState extends State<WomensPlayers> {

  // form key for the transfer dialogue box
  final formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> players = [];

  List<Map<String, dynamic>> teams = [];
  List<Map<String, dynamic>> positions = [];

  List<String> teamDropDownList = [];

  // selected criteria
  String selectedCriteria = "Active";

  // selected team map
  Map<String, dynamic> _selectedTeamMap = {};

  // selected transfer type
  String _selectedTransferType = "Permanent";

  String transferJson = "";

  @override
  void initState() {
    super.initState();

    // Call the function to get the female players when the page loads
    getActiveWomensPlayers().then((result) {
      setState(() {
        players = result;
        filteredPlayers = players;
      });
    });

    // Call the function to get the women's teams when the page loads
    getWomensTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

    // Call the function to get the positions when the page loads
    // This is used to display a player's position name as the list tile's subtitle instead of the position id
    getPositions().then((result) {
      setState(() {
        positions = result;
      });
    });

  }

  String searchQuery = '';

  // list of players for the search bar
  List<Map<String, dynamic>> filteredPlayers = [];

  /// This function is called when the search bar is used.
  void updateFilteredPlayers(String query) {
    filteredPlayers = players.where((player) {
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
            getActiveWomensPlayers().then((result) {
              setState(() {
                players = result;
                filteredPlayers = players;
              });
            });

          }  
          if (newValue == "Retired") {
            getRetiredWomensPlayers().then((result) {
              setState(() {
                players = result;
                filteredPlayers = players;
              });
            });
          }


        });
      }
        
    );

    // if the list of players is empty, return "No players found"
    if (players.isEmpty) {
      return Column(

        children: [

          // player criteria dropdown
          playerCriteriaDropDown,

          SmallAddButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPlayer(
                      pageName: "Add Player",
                    ),
                  ),
                );
            },
            text: "Add Player"
          ),

          const Center(
            child: AppText(
            text: 'No players found',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            )
          ),

        ],
    
      );
    }

    return Scaffold(
      body: Column(
        children: [

          // player criteria dropdown
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

        
          SmallAddButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPlayer(
                      pageName: "Add Player",
                    ),
                  ),
                );
            },
            text: "Add Player"
          ),

          // List of players
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlayers.length,
              itemBuilder: (context, index) {
                final player = filteredPlayers[index];
                final team = teams.firstWhere(
                  (team) => team['team_id'] == player['team_id'],
                  orElse: () => {'team_name': "None"},
                );
                final position = positions.firstWhere(
                  (position) => position['position_id'] == player['position_id'],
                  orElse: () => {'position_name': "None"}, 
                );

                // team dropdown list without the current team
                List <String> teamDropDownList = teams.map((team) => team['team_name'].toString()).toList();
                teamDropDownList.remove(team['team_name']);

                
                return PlayerAdminListTile(
                  title: '${player['fname']} ${player['lname']}',
                  
                  subtitle: team['team_name'],
                    
                  editOnTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => EditPlayer(
                          pageName: 'Edit Player',
                          playerDetailsMap: jsonDecode(
                            convertEditedPlayerDetailsToJson(
                              player['player_id'],
                              player['fname'], 
                              player['lname'], 
                              player['gender'], 
                              player['date_of_birth'], 
                              position['position_name'], 
                              team['team_name'], 
                              player['height'],
                              player['weight'], 
                              player['year_group'], 
                              player['is_retired']
                            )
                          ),
                        )
                      ),
                    );  
                  },

                  deleteOnTap: () {
                    showDialog(
                      // specify the root widget's context. This determines where the dialogue box will be displayed on the screen
                      context: context, 
                      builder: (context) {
                        return DeleteConfirmationDialogBox(
                          title: "Delete Player", 
                          content: "Are you sure you want to delete this player?",
                          onPressed: () async {

                            Map <String, dynamic> response = await deletePlayer(
                              jsonEncode(
                                {
                                  "player_id": player['player_id']
                                }
                              )
                            );

                            if (!mounted) return;

                            if (response['status']) {

                              ErrorHandling.showError(
                                response['message'], 
                                context,
                                "Success"
                              );

                              // refresh the page
                              setState(() {
                                players.removeAt(index);
                              });
                              
                            } else {
                              ErrorHandling.showError(
                                response['message'], 
                                context,
                                "Error"
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
                                player['player_id'],
                                player['team_id'], 
                                _selectedTeamMap['team_id'],
                                DateTime.now().toString().substring(0, 10), 
                                _selectedTransferType
                              );

                              Map <String, dynamic> response = await addTransfer(transferJson);

                              if (!mounted) return;

                              if (response['status']) {

                                // show success dialogue box
                                ErrorHandling.showError(
                                  response['message'], 
                                  context,
                                  "Success"
                                );

                                // refresh the page
                                setState(() {
                                  getActiveWomensPlayers().then((result) {
                                    setState(() {
                                      players = result;
                                      filteredPlayers = players;
                                    });
                                  });
                                });
                                
                              } 
                              
                              else {
                                ErrorHandling.showError(
                                  response['message'], 
                                  context,
                                  "Error"
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
            ) ,
          )
        ]
      // backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      )
    );
  }
}