import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/assist/get_assists_by_game_req.dart';
import 'package:apl/requests/teams/get_team_players_req.dart';
import 'package:flutter/material.dart';
import '../../requests/goal/get_goals_by_team_and_game_req.dart';
import '../helper_classes/scoreline_row.dart';



class GameEvents extends StatefulWidget {
  const GameEvents(
    {
      super.key,
      required this.gameDetails,
      required this.gameweekDetails,
      required this.homeTeam,
      required this.awayTeam,
    }
  );

  final Map<String, dynamic> gameDetails;
  final Map<String, dynamic> gameweekDetails;
  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;

  @override
  _GameEventsState createState() => _GameEventsState();
}

class _GameEventsState extends State<GameEvents> {

  // form key
  GlobalKey <FormState> formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> homeTeamGoals = [];
  List<Map<String, dynamic>> awayTeamGoals = [];
  List<Map<String, dynamic>> homeTeamPlayers = [];
  List<Map<String, dynamic>> awayTeamPlayers = [];

  List<Map<String, dynamic>> playersDropDownMap = [];
  List <String> playersDropDownList = [];

  List <String> goalScorersDropDownList = [];
  List <String> assistDropDownList = [];

  Map <String, dynamic> selectedGoalScorerMap = {};
  Map <String, dynamic> selectedAssistMap = {};

  List<Map<String, dynamic>> teamMap = [];
  List <String> teamDropDownList = [];
  Map <String, dynamic> selectedTeamMap = {};

  List <Map<String, dynamic>> assists = [];

  TextEditingController minuteScoredController = TextEditingController();



  @override
  /// This function is called when the page loads.
  void initState() {
    super.initState();

    // Get goals scored by the home team
     getGoalsByTeamAndGame(widget.homeTeam['team_id'], widget.gameDetails['game_id']).then((result) {
      setState(() {
        homeTeamGoals = result;
      });
    });

    // Get goals scored by the away team
    getGoalsByTeamAndGame(widget.awayTeam['team_id'], widget.gameDetails['game_id']).then((result) {
      setState(() {
        awayTeamGoals = result;
      });
    });

    // Get assists made during the game
    getAssistsByGame(widget.gameDetails['game_id']).then((result) {
      setState(() {
        assists = result;
      });
    });

    // Get players for the team
    if (widget.gameDetails['gender'] == 'Male') {
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
  }


  @override
  Widget build(BuildContext context) {

    // drop downs
    teamMap = [widget.homeTeam, widget.awayTeam];
    teamDropDownList = [widget.homeTeam['team_name'], widget.awayTeam['team_name']];

    playersDropDownMap = homeTeamPlayers + awayTeamPlayers;
    playersDropDownList = playersDropDownMap.map((player) => "${player['fname']} ${player['lname']}").toList();

    goalScorersDropDownList = playersDropDownList;
    assistDropDownList = playersDropDownList;

    // if the gameweek's date hasn't passed, disable the add goal button
    final DateTime gameweekDate = DateTime.parse(widget.gameweekDetails['gameweek_date']);
    final DateTime currentDate = DateTime.now();
    final bool isBefore = gameweekDate.isBefore(currentDate);

    if (!isBefore) {
      return Scaffold (
        body:  StartTimeRow(
          homeTeam: widget.homeTeam,
          awayTeam: widget.awayTeam,
          gameDetails: widget.gameDetails,
        )
      );
    }


    return Scaffold(
      
      // two list views, one for each team
      // one side has the goals scored by the home team and the other side has the goals scored by the away team
      // on top of these list views should be a button to add a goal
      // below that should be a display of the scoreline

      body: Column(
        children: [
          

          // scoreline
          ScoreLineRow (
            homeTeam: widget.homeTeam,
            awayTeam: widget.awayTeam,
            homeTeamGoals: homeTeamGoals,
            awayTeamGoals: awayTeamGoals,
          ),

          // Events
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Row (
                children: [
                  // home team goals
                  Flexible (
                    child: ListView.builder(
                      itemCount: homeTeamGoals.length,
                      itemBuilder: (context, index) {
                        final goal = homeTeamGoals[index];
                        // find matching assist
                        final assist = assists.firstWhere((assist) => assist['goal_id'] == goal['goal_id'], orElse: () => {});
                        return GoalListTile(
                          goal: goal, 
                          assist: assist
                        );
                      }
                    ),
                  ),
                  // away team goals
                  Flexible (
                    child: ListView.builder(
                      itemCount: awayTeamGoals.length,
                      itemBuilder: (context, index) {
                        final goal = awayTeamGoals[index];
                        // find matching assist
                        final assist = assists.firstWhere((assist) => assist['goal_id'] == goal['goal_id'], orElse: () => {});
                        return GoalListTile(
                          goal: goal, 
                          assist: assist
                        );
                      }
                    ),
                  )

                ],
              )
            )
          )
          
        
        ],
      ),
      
    );
    
  }
}