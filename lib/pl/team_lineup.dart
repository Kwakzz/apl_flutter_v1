import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/pl/view_player.dart';
import 'package:apl/requests/formation/get_formations_req.dart';
import 'package:apl/requests/starting_xi/get_team_starting_xi_players_req.dart';
import 'package:apl/requests/starting_xi/get_team_starting_xi_req.dart';
import 'package:apl/requests/teams/get_team_players_req.dart';
import 'package:flutter/material.dart';

import '../../requests/positions/get_positions_req.dart';



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

  List<Map<String, dynamic>> formations = [];
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

            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText(
                text: 'Starting XI not announced yet',
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              )
            ),

          ]
      );
    }

    // prevent the page from crashing if the formation hasn't been loaded yet
    try {

      // team's formation
      // Map <String, dynamic> formation = {};
      // formation = formations.firstWhere((formation) => formation['formation_id'] == teamStartingXI['formation_id'], orElse: () => {});
    
      return ListView(

          children: [

            // Goalkeeper
            const ListTile(
              title: AppText(
                text: "Goalkeeper",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),
            ),
            
            SizedBox(
              height: goalkeeperListViewHeight,
              child: ListView.builder(
                itemCount: goalkeepers.length,
                itemBuilder: (context, index) {

                  final goalkeeper = goalkeepers[index];

                  return StartingXIListTile(
                    player: goalkeeper,
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ViewPlayer(
                            playerMap: goalkeeper
                          )
                        )
                      );
                    }
                  );
                  
                },
              )
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

           SizedBox(
              height: defenderListViewHeight,
              child: ListView.builder(
                itemCount: defenders.length,
                itemBuilder: (context, index) {

                  final defender = defenders[index];

                  return StartingXIListTile(
                    player: defender,
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ViewPlayer(
                            playerMap: defender
                          )
                        )
                      );
                    }
                  );
                  
                },
              )
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

            SizedBox(
              height: midfielderListViewHeight,
              child: ListView.builder(
                itemCount: midfielders.length,
                itemBuilder: (context, index) {

                  final midfielder = midfielders[index];

                  return StartingXIListTile(
                    player: midfielder,
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ViewPlayer(
                            playerMap: midfielder
                          )
                        )
                      );
                    }
                  );
                  
                },
              )
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

            SizedBox(
              height: forwardListViewHeight,
              child: ListView.builder(
                itemCount: forwards.length,
                itemBuilder: (context, index) {

                  final forward = forwards[index];

                  return StartingXIListTile(
                    player: forward,
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ViewPlayer(
                            playerMap: forward
                          )
                        )
                      );
                    }
                  );
                  
                },
              )
            ),
          ]
      );
    }
    catch (e) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.black
        )
      );
    }
  }
}