
import 'package:apl/admin_pages/games/add_cup_game_form.dart';
import 'package:apl/requests/seasons/get_mens_season_comps_req.dart';
import 'package:apl/requests/seasons/get_womens_comps_req.dart';
import 'package:apl/requests/stage/get_all_stages_req.dart';
import 'package:apl/requests/teams/get_mens_teams_req.dart';
import 'package:apl/requests/teams/get_womens_teams_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_appbar.dart';

class AddCupGame extends StatefulWidget {
  const AddCupGame(
    {
      super.key,
      required this.pageName,
      required this.gameweekDetails,
    }
  );

  // The name of the page
  final String pageName;

  // The map of the game week
  final Map<String, dynamic> gameweekDetails;

  @override
  _AddCupGameState createState() => _AddCupGameState();
}

class _AddCupGameState extends State<AddCupGame> {


  List<Map<String, dynamic>> mensComps = [];
  List<Map<String, dynamic>> womensComps = [];
  List<Map<String, dynamic>> mensTeams = [];
  List<Map<String, dynamic>> womensTeams = [];
  List<Map<String, dynamic>> stages = [];



  @override
  /// This function is called when the page loads.
  /// It calls the function to get the teams and competitions being played in the season.
  void initState() {
    super.initState();

    // Call the function to get the men's competitions for the season when the page loads
    getMensSeasonComps(widget.gameweekDetails['season_id']).then((result) {
      setState(() {
        mensComps = result;
      });
    });

    // Call the function to get the men's competitions for the season when the page loads
    getWomensSeasonComps(widget.gameweekDetails['season_id']).then((result) {
      setState(() {
        womensComps = result;
      });
    });

    // call the function get the men's teams when the page loads
    getMensTeams().then((result) {
      setState(() {
        mensTeams = result;
      });
    });

    // call the function get the men's teams when the page loads
    getWomensTeams().then((result) {
      setState(() {
        womensTeams = result;
      });
    });

    // call the function to get the stages of tournaments
    getStages().then((result) {
      setState(() {
        stages = result;
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
            pageName: "Add Cup Game",
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: TabBarView(
            children: [
              // Men's view
              AddCupGameForm(
                gameweek: widget.gameweekDetails,
                seasonCompsMap: mensComps,
                teamsMap: mensTeams,
                stages: stages,
              ),
              // Women's view
              AddCupGameForm(
                gameweek: widget.gameweekDetails,
                seasonCompsMap: womensComps,
                teamsMap: womensTeams,
                stages: stages,
              ),
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
    );





  }
}