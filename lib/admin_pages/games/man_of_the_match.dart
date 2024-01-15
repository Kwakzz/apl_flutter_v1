import 'dart:convert';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/error_handling.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:apl/requests/man_of_the_match/change_motm_req.dart';
import 'package:apl/requests/man_of_the_match/get_motm_req.dart';
import 'package:apl/requests/man_of_the_match/set_motm_req.dart';
import 'package:apl/requests/teams/get_team_players_req.dart';
import 'package:flutter/material.dart';

import '../../helper_classes/custom_dropdown.dart';



class MOTM extends StatefulWidget {
  const MOTM(
    {
      super.key,
      required this.game,
      required this.homeTeam,
      required this.awayTeam,
    }
  );

  final Map<String, dynamic> game;
  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;

  @override
  _MOTMState createState() => _MOTMState();
}

class _MOTMState extends State<MOTM> {

  // dialog box form key
  final _formKey = GlobalKey<FormState>();


  Map<String, dynamic> selectedMOTM = {};

  Map <String, dynamic> motm = {};

  List<Map<String, dynamic>> homeTeamPlayers = [];
  List<Map<String, dynamic>> awayTeamPlayers = [];

  List<Map<String, dynamic>> playersDropDownMap = [];
  List<String> playersDropDownList = [];


  

  @override
  void initState() {
    super.initState();

    // Get players for the team
    if (widget.game['gender'] == 'Male') {
      getActiveMensTeamPlayers(widget.homeTeam['team_id']).then((result) {
        setState(() {
          homeTeamPlayers = result;
        });
      });

      getActiveMensTeamPlayers(widget.awayTeam['team_id']).then((result) {
        setState(() {
          awayTeamPlayers = result;
        });
      });

    
    } else {
      getActiveWomensTeamPlayers(widget.homeTeam['team_id']).then((result) {
        setState(() {
          homeTeamPlayers = result;
        });
      });

      getActiveWomensTeamPlayers(widget.awayTeam['team_id']).then((result) {
        setState(() {
          awayTeamPlayers = result;
        });
      });
    }

    getMOTM(widget.game['game_id']).then((result) {
      setState(() {
        motm = result;
        selectedMOTM = result;

      });
    });

  }

  



  @override
  Widget build(BuildContext context) {

    playersDropDownMap = homeTeamPlayers + awayTeamPlayers;
    playersDropDownList = playersDropDownMap.map((player) => "${player['fname']} ${player['lname']}").toList();

    // drop down list for players
    SignUpDropdownFormField playersDropDown = SignUpDropdownFormField(
      items: playersDropDownList,
      labelText: "MOTM",
      onChanged: (newValue) {
        setState(() {

          selectedMOTM = playersDropDownMap.firstWhere(
            (player) => '${player['fname']} ${player['lname']}' == newValue,
            orElse: () => {},
          );

        }
        );
      }
    );


    return Scaffold(

      body: Builder(
        builder: (context){
          return ListView(
            children: [
          
              SmallAddButton(

                onPressed: () {

                  showDialog(
                    context: context, 
                    builder: (context) {
                      return SelectMOTMDialogBox(
                        playersDropDown: playersDropDown, 
                        formKey: _formKey,
                        onSubmit: () async {
                          
                          String motmJson = jsonEncode(<String, dynamic>{
                            'game_id': widget.game['game_id'],
                            'player_id': selectedMOTM['player_id'],
                          });

                          
                          Map <String, dynamic> response = {}; 
                          
                          if (motm.isEmpty) {
                            response = await setManOfTheMatch(motmJson);
                          } else {
                            response = await changeManOfTheMatch(motmJson);
                          }

                          if (!mounted) return;

                          if (response['status']) {
                            getMOTM(widget.game['game_id']).then((result) {
                              setState(() {
                                motm = result;
                                selectedMOTM = result;
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
                      );
                    },
                  );
                },
                text: "Select MOTM",
              ),

              if (motm.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(255, 0, 53, 91),
                  height: 170,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "${motm['fname']} ${motm['lname']}",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              AppText(
                                text: motm['position_name'],
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Expanded(
                            child: motm['player_image_url'] == null || motm['player_image_url'] == '' ? const Icon(Icons.image_not_supported, size: 13):  Image.network(
                              motm['player_image_url'],
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              scale: 0.5,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 150,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              
                    
            ]
          );

        }
      ) 
    );


  }
    
}
