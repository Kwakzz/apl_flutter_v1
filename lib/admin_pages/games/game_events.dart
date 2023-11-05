import 'dart:convert';
import 'package:apl/helper_classes/app_bar_bottom_row.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/error_handling.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/helper_functions/convert_to_json.dart';
import 'package:apl/requests/assist/get_assists_by_game_req.dart';
import 'package:apl/requests/goal/add_goal_req.dart';
import 'package:apl/requests/goal/delete_goal_req.dart';
import 'package:apl/requests/teams/get_team_players_req.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper_classes/scoreline_row.dart';
import '../../requests/goal/get_goals_by_team_and_game_req.dart';


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

  void refreshData () {
    // Refresh the page
    getGoalsByTeamAndGame(widget.homeTeam['team_id'], widget.gameDetails['game_id']).then((result) {
      setState(() {
        homeTeamGoals = result;
      });
    });

    getGoalsByTeamAndGame(widget.awayTeam['team_id'], widget.gameDetails['game_id']).then((result) {
      setState(() {
        awayTeamGoals = result;
      });
    });

    getAssistsByGame(widget.gameDetails['game_id']).then((result) {
      setState(() {
        assists = result;
      });
    });

  }



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
          
          // add goal button
          AppBarBottomRow(
            children: [
              AddButton(
                onPressed: (){
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return AddGoalDialogBox(
                        teamDropDownList: teamDropDownList, 
                        goalScorersDropDownList: goalScorersDropDownList,
                        assistDropDownList: assistDropDownList, 
                        teamDropDownOnChanged: (value){
                          setState(() {
                            selectedTeamMap = teamMap[teamDropDownList.indexOf(value!)];
                          });
                        },
                        goalDropDownOnChanged: (value){
                          setState(() {
                            selectedGoalScorerMap = playersDropDownMap[goalScorersDropDownList.indexOf(value!)];
                          });
                        },
                        assistDropDownOnChanged: (value){
                          setState(() {
                            selectedAssistMap = playersDropDownMap[assistDropDownList.indexOf(value!)];
                          });
                        }, 
                        submitButtonOnPressed: () async {
                          Map<String, dynamic> response = await addGoal(
                            createGoalJson(
                              widget.gameDetails['game_id'], 
                              selectedGoalScorerMap['player_id'], 
                              selectedAssistMap['player_id'], 
                              minuteScoredController.text,
                              selectedTeamMap['team_id'],
                            )
                          );

                          if (!mounted) return;

                          if (response['status']) {

                            // refresh the page
                            refreshData();

                            
                          }

                          else {
                            ErrorHandling.showError(
                              response['message'], 
                              context,
                              'Error'
                            );
                          }

                        }, 
                        teamValidator: (value){
                          if (value == null) {
                            return "Please select a team";
                          }
                          return null;
                        },
                        goalValidator: (value){
                          if (value == null) {
                            return "Please select a goal scorer";
                          }
                          return null;
                        },
                        assistValidator: (value) {
                          if (value == '${selectedGoalScorerMap['fname']} ${selectedGoalScorerMap['lname']}') {
                            return "Goal scorer and assist provider cannot be the same player";
                          }
                          // check if assist provider is from the same team as the goal scorer
                          if (value != null && selectedGoalScorerMap['team_id'] != selectedAssistMap['team_id']) {
                            return "Assist provider must be from the same team as the goal scorer";
                          }
                          return null;
                        },
                        minuteScoredController: minuteScoredController, 
                        formKey: formKey
                      );
                    }
                  );
                },
                text: "Add Goal",
                
              ),
              AddButton(
                onPressed: (){},
                text: "Add Booking"
              )
            ]
          ),

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
                        return ListTile(
                          leading: const Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Icon(
                              Icons.sports_soccer,
                              size: 12,
                            ),
                          ),
                          title: AppText(
                            text: "${goal['minute_scored']}'",
                            fontWeight: FontWeight.w500,
                            fontSize: 12, 
                            color: Colors.black,
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${goal['fname']}",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12, 
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${goal['lname']}",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13, 
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: assist.isEmpty ? "" : " (${assist['fname']} ${assist['lname']})",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12, 
                                    color: Colors.black,
                                  ),
                                ),
                                
                              ]
                            ),
                          ),
                          // delete icon
                          trailing: IconButton(
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return DeleteConfirmationDialogBox(
                                    title: "Delete Goal", 
                                    content: "Are you sure you want to delete this goal?", 
                                    onPressed: () async {
                                      Map<String, dynamic> response = await deleteGoal(jsonEncode({'goal_id': goal['goal_id']}));

                                      if (!mounted) return;

                                      if (response['status']) {

                                        // refresh the page
                                        refreshData();

                                      
                                      }

                                      else {

                                        ErrorHandling.showError(
                                          response['message'], 
                                          context,
                                          'Error'
                                        );

                                      }
                                    }
                                  );
                                }
                              );
                            }, 
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 13,
                            )
                          ),
                          
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
                        return ListTile(
                          leading: const Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Icon(
                              Icons.sports_soccer,
                              size: 12,
                            ),
                          ),
                          title: AppText(
                            text: "${goal['minute_scored']}'",
                            fontWeight: FontWeight.w500,
                            fontSize: 12, 
                            color: Colors.black,
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${goal['fname']}",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12, 
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${goal['lname']}",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13, 
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: assist.isEmpty ? "" : " (${assist['fname']} ${assist['lname']})",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12, 
                                    color: Colors.black,
                                  ),
                                ),
                                
                              ]
                            ),
                          ),
                          // delete icon
                          trailing: IconButton(
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return DeleteConfirmationDialogBox(
                                    title: "Delete Goal", 
                                    content: "Are you sure you want to delete this goal?", 
                                    onPressed: (){
                                      deleteGoal(jsonEncode({'goal_id': goal['goal_id']}));
                                      refreshData();
                                    }
                                  );
                                }
                              );
                            }, 
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 14,
                            )
                          ),
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