import 'dart:convert';

import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:apl/requests/standings/delete_standings_team_req.dart';
import 'package:apl/requests/standings/get_standings_teams_req.dart';
import 'package:apl/requests/teams/get_mens_teams_req.dart';
import 'package:apl/requests/teams/get_womens_teams_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../requests/standings/add_standings_team_req.dart';


class StandingsTeams extends StatefulWidget {
  const StandingsTeams(
    {
      super.key,
      required this.standingsInfo
    }
  );

  final Map<String, dynamic> standingsInfo;

  @override
  _StandingsTeamsState createState() => _StandingsTeamsState();
}

class _StandingsTeamsState extends State<StandingsTeams> {

  // form key
  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> standingsTeams = [];

  List<Map<String, dynamic>> mensTeams = [];

  List<Map<String, dynamic>> womensTeams = [];

  List<Map<String, dynamic>> teams = [];

  Map <String, dynamic> _selectedTeamMap = {};

  

  @override
  void initState() {
    super.initState();

    getStandingsTeams(widget.standingsInfo['standings_id']).then((result) {
      setState(() {
        standingsTeams = result;
      });
    });

    
    getMensTeams().then((result) {
      setState(() {
        mensTeams = result;
      });
    });

    getWomensTeams().then((result) {
      setState(() {
        womensTeams = result;
      });
    });


  }

  void refreshStandingsTeams() {
      getStandingsTeams(widget.standingsInfo['standings_id']).then((result) {
        setState(() {
          standingsTeams = result;
        });
      });
    }


  @override
  Widget build(BuildContext context) {

    final List<String> teamNames = [];

    try {

      if (widget.standingsInfo['gender'] == 'Female') {
        for (var team in womensTeams) {
          teamNames.add(team['team_name']);
        }
        teams = womensTeams;
      } 
      if (widget.standingsInfo['gender'] == 'Male') {
        for (var team in mensTeams) {
          teamNames.add(team['team_name']);
        }
        teams = mensTeams;
      }
    } catch (e) {
      const CircularProgressIndicator(
        backgroundColor: Colors.white,
        color: Colors.blue,
      );
    }

    // if the list of players is empty, return "No players found"
    if (standingsTeams.isEmpty) {
      return  Scaffold(

        appBar: CustomAppbar(
          icon: const Icon(
            Icons.arrow_back_ios,
          ), 
          pageName: widget.standingsInfo['competition_name'],
          prevContext: context,
        ),

        body: Column(
          children: [

            SmallAddButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) {
                    return AddStandingsTeamDialogBox(
                      formKey: _formKey,
                      teamDropDownList: teamNames,
                        teamDropDownOnChanged: (newValue) {
                          setState(() {
                            _selectedTeamMap = teams.firstWhere(
                              (comp) => comp["team_name"].toString() == newValue,
                              orElse: () => {},
                            );
                          });
                        },
                      teamValidator: (value) {
                        if (value == null) {
                          return 'Please select a team';
                        }

                        // Check if the selected team is already in standingsTeams list
                        if (standingsTeams.any((team) => team['team_id'] == _selectedTeamMap['team_id'])) {
                          return 'Team already in standings';
                        }

                        return null;

                      },
                      submitButtonOnPressed: () {
                        addStandingsTeam(
                          jsonEncode(
                            {
                              'standings_id': widget.standingsInfo['standings_id'],
                              'team_id': _selectedTeamMap['team_id'],
                            }
                          )
                        );
                        refreshStandingsTeams();
                      }
                    );
                  }
                );
              },
              text: "Add Team"
            ),

            const Center(
              child: AppText(
              text: 'No teams found',
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.black,
              )
            ),

          ],
    
        )
      );
    }

    return Scaffold(

      appBar: CustomAppbar(
        icon: const Icon(
          Icons.arrow_back_ios,
        ), 
        pageName: '${widget.standingsInfo['competition_abbrev']} ${widget.standingsInfo['standings_name']}',
        prevContext: context,
      ),

      body: Column(
        children: [

          SmallAddButton(
            onPressed: () {
              showDialog(
                  context: context, 
                  builder: (context) {
                    return AddStandingsTeamDialogBox(
                      formKey: _formKey,
                      teamDropDownList: teamNames,
                        teamDropDownOnChanged: (newValue) {
                          setState(() {
                            _selectedTeamMap = teams.firstWhere(
                              (team) => team["team_name"].toString() == newValue,
                              orElse: () => {},
                            );
                          });
                        },
                        
                      teamValidator: (value) {
                        if (value == null) {
                          return 'Please select a team';
                        }

                        // Check if the selected team is already in standingsTeams list
                        if (standingsTeams.any((team) => team['team_id'] == _selectedTeamMap['team_id'])) {
                          return 'Team already in standings';
                        }
                        return null;
                      },
                      submitButtonOnPressed: () async {
                        Map<String, dynamic> response = await addStandingsTeam(
                          jsonEncode(
                            {
                              'standings_id': widget.standingsInfo['standings_id'],
                              'team_id': _selectedTeamMap['team_id'],
                            }
                          )
                        );

                        if (!mounted) return;

                        if (response['status']) {
                          refreshStandingsTeams();

                          showDialog(
                            context: context, 
                            builder:(context) {
                              return ErrorDialogueBox(
                                content: response['message'], 
                                text: "Success",
                                    
                              );
                            } 
                          );
                        }

                        if (response['status'] == 'error') {
                          showDialog(
                            context: context, 
                            builder:(context) {
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
            text: "Add Team"
          ),

          // List of fans
          Expanded(
            child: ListView.builder(
              itemCount: standingsTeams.length,
              itemBuilder: (context, index) {
                final standingsTeam = standingsTeams[index];

                
                return AdminListTileWithoutSubtitle(
                  title: standingsTeam['team_name'],
                  editOnTap: () {
                   
                  }, 
                  deleteOnTap: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return DeleteConfirmationDialogBox(
                          title: "Delete Team", 
                          content: "Are you sure you want to delete this team?", 
                          onPressed: () async {

                            Map<String, dynamic> response = await
                            deleteStandingsTeam(
                              jsonEncode(
                                {
                                  'standings_id': widget.standingsInfo['standings_id'],
                                  'team_id': standingsTeam['team_id'],
                               }
                              )
                            );

                            if (!mounted) return;

                            if (response['status']) {

                              // Remove the deleted team from the list. This will update the UI
                              setState(() {
                                standingsTeams.removeAt(index);
                              });
                            
                              showDialog(
                                context: context, 
                                builder:(context) {
                                  return ErrorDialogueBox(
                                    content: response['message'], 
                                    text: "Success",
                                            
                                  );
                                } 
                              );
                            }

                            else {
                              showDialog(
                                context: context, 
                                builder:(context) {
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
                );
              },
            )
          ),
        ]
      )
    );
  }
}