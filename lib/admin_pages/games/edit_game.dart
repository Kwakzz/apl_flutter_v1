
import 'package:apl/admin_pages/games/edit_game_form.dart';
import 'package:apl/requests/seasons/get_mens_season_comps_req.dart';
import 'package:apl/requests/seasons/get_womens_comps_req.dart';
import 'package:apl/requests/teams/get_mens_teams_req.dart';
import 'package:apl/requests/teams/get_womens_teams_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_appbar.dart';

class EditGame extends StatefulWidget {
  const EditGame(
    {
      super.key,
      required this.pageName,
      required this.gameDetails,
      required this.gameweekDetails,
    }
  );

  // The name of the page
  final String pageName;

  // The map of the game
  final Map<String, dynamic> gameDetails;

  // The map of the game week
  final Map<String, dynamic> gameweekDetails;

  @override
  _EditGameState createState() => _EditGameState();
}

class _EditGameState extends State<EditGame> {

  // form key
  final _formKey = GlobalKey<FormState>();


  List<Map<String, dynamic>> mensComps = [];
  List<Map<String, dynamic>> womensComps = [];
  List<Map<String, dynamic>> mensTeams = [];
  List<Map<String, dynamic>> womensTeams = [];



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
    

  }

  @override
  Widget build(BuildContext context) {

    if (widget.gameDetails['gender'] == 'Female') {

      return Scaffold (
        appBar: CustomAppbar(
          pageName: "Edit Game",
          icon: const Icon(Icons.arrow_back),
          prevContext: context,
        ),


      
        body :EditGameForm(
          gameDetails: widget.gameDetails,
          seasonCompsMap: womensComps,
          teamsMap: womensTeams,
        ),

        backgroundColor: const Color.fromARGB(255, 0, 53, 91),

      );
      
    }

  return Scaffold (
    appBar: CustomAppbar(
      pageName: "Edit Game",
      icon: const Icon(Icons.arrow_back),
      prevContext: context,
    ),


      
    body :EditGameForm(
      gameDetails: widget.gameDetails,
      seasonCompsMap: mensComps,
      teamsMap: mensTeams,
    ),

    backgroundColor: const Color.fromARGB(255, 0, 53, 91),

  );
    

  }
}