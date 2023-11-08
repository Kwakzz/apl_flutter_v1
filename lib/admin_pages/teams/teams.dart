import 'dart:convert';

import 'package:apl/admin_pages/teams/add_team.dart';
import 'package:apl/admin_pages/teams/edit_team.dart';
import 'package:apl/admin_pages/teams/team_players.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/teams/delete_team_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../requests/teams/get_teams_req.dart';
import '../../helper_classes/search_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {

  List<Map<String, dynamic>> teams = [];
  List<Map<String, dynamic>> filteredTeams = [];


  @override
  /// This function is called when the page loads.
  /// It calls the function to get the teams.
  /// It also sets the filteredTeams list to the teams list.
  void initState() {
    super.initState();

    // Call the function to get the teams when the page loads
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

  }

   void filterFans(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredTeams = teams; // Show all fans when search term is empty
      } else {
        filteredTeams = teams.where((team) {
          final teamName = '${team['team_name']}';
          return teamName.toLowerCase().contains(searchTerm.toLowerCase());
        }).toList();
      }
    });
  }

  // Team logo
  File? _teamLogo;

  // Pick an image from the gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _teamLogo = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if the list of teams is empty, return "No teams found"
    if (teams.isEmpty) {
      return  Column(

        children: [
          SmallAddButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTeam(
                      pageName: "Add Team",
                    ),
                  ),
                );
            },
            text: "Add Team"
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText(
                text: 'No teams found',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )
            )
          ),

        ],
    
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          SearchField(
            onChanged: (value) {
              filterFans(value!);
            },
            labelText: 'Search by name',
          ),

          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTeam(
                    pageName: "Add Team",
                  ),
                ),
              );
            },
            text: "Add Team"
          ),

          // List of teams
          Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
          
                
                return AdminListTileWithOnTap(
                  title: '${team['team_name']}',
                  subtitle: '${team['team_name_abbrev']}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamPlayers(
                          team: team,
                        ),
                      ),
                    );
                  },
                  editOnTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTeam(
                          pageName: "Edit Team",
                          team: team,
                        ),
                      ),
                    );
                  },
                  
                  deleteOnTap: (){   
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return DeleteConfirmationDialogBox(
                          title: "Delete Team", 
                          content: "Are you sure you want to delete this team?", 
                         onPressed: () async {

                            Map <String, dynamic> response = await deleteTeam(
                              jsonEncode(
                                {
                                  "team_id": team['team_id']
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
                                teams.removeAt(index);
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
                  } 
                );
              },
            )
          ),
        ]
      )
    );
  }
}