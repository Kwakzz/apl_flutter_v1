import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/pl/view_player.dart';
import 'package:apl/requests/positions/get_positions_req.dart';
import 'package:apl/requests/teams/get_team_players_req.dart';
import 'package:flutter/material.dart';




class ClubSquad extends StatefulWidget {
  const ClubSquad(
    {
      super.key,
      required this.team,
    }
  );

  // The map of the team
  final Map<String, dynamic> team;

  @override
  _ClubSquadState createState() => _ClubSquadState();
}

class _ClubSquadState extends State<ClubSquad> {

  List<Map<String, dynamic>> activeMensTeamPlayers = [];

  List<Map<String, dynamic>> activeWomensTeamPlayers = [];

  List<Map<String, dynamic>> teamPlayers = [];

  List<Map<String, dynamic>> positions = [];



  @override
  /// This function is called when the page loads.
  /// It calls the function to get the fans, teams and positions.
  /// It also sets the filteredCoaches list to the coaches list.
  void initState() {
    super.initState();

    getActiveMensTeamPlayers(widget.team['team_id']).then((result) {
      setState(() {
        activeMensTeamPlayers = result;
        teamPlayers = activeMensTeamPlayers;
      });
    });

    getActiveWomensTeamPlayers(widget.team['team_id']).then((result) {
      setState(() {
        activeWomensTeamPlayers = result;
      });
    });

    getPositions().then((result) {
      setState(() {
        positions = result;
      });
    });

    




  }


  @override
  Widget build(BuildContext context) {


    MyDropdownFormField genderDropDown = MyDropdownFormField(
      items: const [
        "Men",
        "Women"
      ],
      selectedValue: "Men",
      labelText: "",
      onChanged: (newValue) {
        // if user selects men, show mens team players
        if (newValue == "Men") {
          setState(() {
            teamPlayers = activeMensTeamPlayers;
          });
        } else {
          setState(() {
            teamPlayers = activeWomensTeamPlayers;
          });
        }
      }
    );



    return Scaffold(
      body: Column(
        children: [

          // Drop down menu for gender
          genderDropDown,

    
          // List of players in the team
          Expanded(
            child: ListView.builder(
              itemCount: teamPlayers.length,
              itemBuilder: (context, index) {
                final teamPlayer = teamPlayers[index];
                final position = positions.firstWhere(
                  (position) => position['position_id'] == teamPlayer['position_id'],
                  orElse: () => {'position_name': "None"}, 
                );
                
                return PlayerListTile(
                  playerName: '${teamPlayer['fname']} ${teamPlayer['lname']}',
                  teamName: position['position_name'],
                  playerImageURL: teamPlayer['player_image_url'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPlayer(
                          playerMap: teamPlayer,
                        ),
                      ),
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