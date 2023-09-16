
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/pl/view_player.dart';
import 'package:apl/requests/players/get_mens_players_req.dart';
import 'package:flutter/material.dart';
import '../../../helper_classes/custom_dropdown.dart';
import '../../../requests/teams/get_teams_req.dart';
import '../../../helper_classes/search_field.dart';


class MensPlayers extends StatefulWidget {
  const MensPlayers({super.key});

  @override
  _MensPlayersState createState() => _MensPlayersState();
}

class _MensPlayersState extends State<MensPlayers> {

  List<Map<String, dynamic>> players = [];

  List<Map<String, dynamic>> teams = [];
  List<Map<String, dynamic>> positions = [];

  // selected criteria
  String selectedCriteria = "Active";

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the fans, teams and positions.
  /// It also sets the filteredPlayers list to the players list.
  void initState() {
    super.initState();

    // Call the function to get the male players when the page loads
    getActiveMensPlayers().then((result) {
      setState(() {
        players = result;
        filteredPlayers = players;
      });
    });

    // Call the function to get the teams when the page loads
    getTeams().then((result) {
      setState(() {
        teams = result;
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
            getActiveMensPlayers().then((result) {
              setState(() {
                players = result;
              });
            });

          } 

          if (newValue == "Retired") {
            getRetiredMensPlayers().then((result) {
              setState(() {
                players = result;
              });
            });
          }
        });
      }
        
    );


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
                
                return PlayerListTile(
                  playerName: '${player['fname']} ${player['lname']}', 
                  teamName: team['team_name'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPlayer(
                          playerMap: player,
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