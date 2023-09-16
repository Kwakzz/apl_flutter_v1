
import 'package:apl/admin_pages/teams/mens_team_players.dart';
import 'package:apl/admin_pages/teams/womens_team_players.dart';
import 'package:flutter/material.dart';
import '../../requests/teams/get_team_players_req.dart';
import '../../requests/positions/get_positions_req.dart';
import '../../helper_classes/custom_appbar.dart';


class TeamPlayers extends StatefulWidget {
  const TeamPlayers(
    {
      super.key,
      required this.team,
    }
  );

  // The map of the team
  final Map<String, dynamic> team;

  @override
  _TeamPlayersState createState() => _TeamPlayersState();
}

class _TeamPlayersState extends State<TeamPlayers> {


  List<Map<String, dynamic>> teamPlayers = [];
  List<Map<String, dynamic>> filteredTeamPlayers = [];
  List<Map<String, dynamic>> positions = [];



  @override
  /// This function is called when the page loads.
  /// It calls the function to get the teams.
  /// It also sets the filteredTeams list to the teams list.
  void initState() {
    super.initState();

    // Call the function to get the teams when the page loads
    getTeamPlayers(widget.team['team_id']).then((result) {
      setState(() {
        teamPlayers = result;
      });
    });

    // Call the function to get the positions when the page loads
    // This is used to display the position name instead of the position id
    getPositions().then((result) {
      setState(() {
        positions = result;
      });
    });

  }

   void filterFans(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredTeamPlayers = teamPlayers; // Show all players in the team when search term is empty
      } else {
        filteredTeamPlayers = teamPlayers.where((player) {
          final teamName = '${player['fname']} ${player['lname']}';
          return teamName.toLowerCase().contains(searchTerm.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // The tabs for the tab bar
    final List<Tab> myTabs = <Tab>[
      const Tab(text: 'Men'),
      const Tab(text: 'Women'),
    ];

    return Scaffold(
       body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppbarWithTabs(
            height: 100,
            pageName: widget.team['team_name'],
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: TabBarView(
            children: [
              MensTeamPlayers(
                team: widget.team
              ),
              WomensTeamPlayers(
                team: widget.team
              ),
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
    );
  }
}