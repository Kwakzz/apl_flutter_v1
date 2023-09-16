import 'package:apl/pl/club_squad.dart';
import 'package:apl/pl/team_stats.dart';
import 'package:flutter/material.dart';
import '../../../requests/teams/get_team_players_req.dart';
import '../../../requests/positions/get_positions_req.dart';

import '../../../helper_classes/custom_appbar.dart';


class ClubDetails extends StatefulWidget {
  const ClubDetails(
    {
      super.key,
      required this.team,
    }
  );

  // The map of the team
  final Map<String, dynamic> team;

  @override
  _ClubDetailsState createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails> {


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


  @override
  Widget build(BuildContext context) {

    // The tabs for the tab bar
    final List<Tab> myTabs = <Tab>[
      const Tab(text: 'Squad'),
      const Tab(text: 'Team Stats'),
    ];

    return Scaffold(
       body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppbarWithTabs(
            // if color_code is empty string, use the default color
            color: widget.team['color_code'] == '' ? const Color.fromARGB(255, 0, 53, 91) : Color(int.parse('0xFF${widget.team['color_code']}')),
            height: 100,
            pageName: widget.team['team_name'],
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: TabBarView(
            children: [
               ClubSquad(
                team: widget.team,
              ),
          
              TeamStats(
                team: widget.team
              )
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
    );
  }
}