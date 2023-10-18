//import 'package:apl/admin_pages/games/game_events.dart';
import 'package:apl/admin_pages/games/game_events.dart';

import 'package:apl/admin_pages/games/game_lineups.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../requests/teams/get_teams_req.dart';



class GameDetails extends StatefulWidget {
  const GameDetails(
    {
      super.key,
      required this.pageName,
      required this.gameDetails,
      required this.homeTeam,
      required this.awayTeam,
      required this.gameweekDetails
    }
  );

  final String pageName;
  final Map<String, dynamic> gameDetails;
  final Map<String, dynamic> gameweekDetails;
  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;

  @override
  _GameDetailsState createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {


  List<Map<String, dynamic>> teams = [];
  List <Map<String, dynamic>> mensGames = [];
  List <Map<String, dynamic>> womensGames = [];

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the seasons
  void initState() {
    super.initState();



    // get teams when the page loads
    // they are needed to display the team name instead of the team id so that we can
    // have something like "Elite vs Kasanoma" instead of "1 vs 2"
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });
  }



  @override
  Widget build(BuildContext context) {

     List <Widget> myTabs = const [
      Tab(
        text: "Events"
      ),
      Tab(
        text: "Lineups"
      ),
      Tab(
        text: "MOTM"
      ),
    ];
    
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: CustomAppbarWithTabs(
            pageName: widget.pageName,
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: TabBarView(
            children: [
              GameEvents(
                gameDetails: widget.gameDetails, 
                homeTeam: widget.homeTeam, 
                awayTeam: widget.awayTeam,
                gameweekDetails: widget.gameweekDetails,
              ),
              GameLineups(
                gameDetails: widget.gameDetails,
                homeTeam: widget.homeTeam,
                awayTeam: widget.awayTeam,
              ),
              const Text(""),
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
    );
  }
}