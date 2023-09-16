import 'package:apl/admin_pages/games/games_view.dart';
import 'package:apl/requests/games/get_mens_gw_games_req.dart';
import 'package:apl/requests/games/get_womens_gw_games_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../requests/teams/get_teams_req.dart';



class Games extends StatefulWidget {
  const Games(
    {
      super.key,
      required this.gameweekMap
    }
  );

  final Map<String, dynamic> gameweekMap;

  @override
  _GamesState createState() => _GamesState();
}

class _GamesState extends State<Games> {


  List<Map<String, dynamic>> teams = [];
  List <Map<String, dynamic>> mensGames = [];
  List <Map<String, dynamic>> womensGames = [];

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the seasons
  void initState() {
    super.initState();

    // Call the function to get the men's games when the page loads
    getMensGameweekGames(widget.gameweekMap['gameweek_id']).then((result) {
      setState(() {
        mensGames = result;
      });
    });

    // Call the function to get the women's games when the page loads
    getWomensGameweekGames(widget.gameweekMap['gameweek_id']).then((result) {
      setState(() {
        womensGames = result;
      });
    });

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
        text: "Men's"
      ),
      Tab(
        text: "Women's"
      ),
    ];
    
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppbarWithTabs(
            pageName: "Add Game",
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: TabBarView(
            children: [

              // men's games
              GamesView(
                gameweekMap: widget.gameweekMap, 
                games: mensGames, 
                teams: teams
              ),

              // women's games
              GamesView(
                gameweekMap: widget.gameweekMap, 
                games: womensGames, 
                teams: teams
              ), 
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
    );
  }
}