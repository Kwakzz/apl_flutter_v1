import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/pl/game_details.dart';
import 'package:apl/requests/goal/get_goals_by_season_and_comp_req.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'helper_classes/text.dart';



class LatestResults extends StatefulWidget {
  const LatestResults(
    {
      super.key,
      required this.fixtures,
      required this.teams,
      required this.selectedGameweekMap,
      required this.onPressed,
      required this.selectedSeasonId,
      required this.selectedCompId,
    }
  );

  final List<Map<String, dynamic>> fixtures;
  final List<Map<String, dynamic>> teams;
  final Map<String, dynamic> selectedGameweekMap;
  final Function () ? onPressed;
  final int selectedSeasonId;
  final int selectedCompId;
  


  @override
  _LatestResultsState createState() => _LatestResultsState();
}

class _LatestResultsState extends State<LatestResults> {

  @override
  void initState() {
    super.initState();
    getGoalsBySeasonAndCompetition(widget.selectedSeasonId, widget.selectedCompId).then((result) {
      setState(() {
        goals = result;
                  
      });
    });
  }



  List<Map<String, dynamic>> teamMap = [];
  List <String> teamDropDownList = [];
  Map <String, dynamic> selectedTeamMap = {};
  List<Map<String, dynamic>> goals = [];


  @override
  Widget build(BuildContext context) {

    SizedBox fixtures = SizedBox(
      // height is the length of the listview itemcount
      height: 70.0 * widget.fixtures.length,
      child: ListView.builder(
              
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.fixtures.length,
        itemBuilder: (context, index) {
          final fixture = widget.fixtures[index];
          final homeTeam = widget.teams.firstWhere((team) => 
          team['team_id'] == fixture['home_id']);
          final awayTeam = widget.teams.firstWhere((team) => team['team_id'] == fixture['away_id']);

          // Find the goals which match the fixture id and home team id to get the number of goals scored by the home team
          final homeGoals = goals.where((goal) => goal['game_id'] == fixture['game_id'] && goal['team_id'] == fixture['home_id']).toList();
          
          final homeTeamScore = homeGoals.length;

          // Find the goals which match the fixture id and away team id to get the number of goals scored by the away team
          final awayGoals = goals.where((goal) => goal['game_id'] == fixture['game_id'] && goal['team_id'] == fixture['away_id']).toList();
          final awayTeamScore = awayGoals.length;

          try {
            return ResultsGraphicListTile(
                  
              homeTeam: homeTeam,
              homeTeamScore: homeTeamScore,
              awayTeam: awayTeam,
              awayTeamScore: awayTeamScore,
              gameDetails: fixture,
              
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameDetails(
                    pageName: '${homeTeam['team_name_abbrev']} vs ${awayTeam['team_name_abbrev']}',
                    homeTeam: homeTeam,
                    awayTeam: awayTeam,
                    gameDetails: fixture,
                    gameweekDetails: widget.selectedGameweekMap,
                  )),
                );
              }
            );
          } catch (e) {
            return const CircularProgressIndicator();
          }
                
        }
              
          
      )
    );

    if (widget.fixtures.isEmpty || widget.teams.isEmpty || widget.selectedGameweekMap.isEmpty) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), 
        strokeWidth: 2, 
      );
    }
    
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration:  BoxDecoration(
        color: Colors.white,
        border: Border.all(  
          color:  const Color.fromARGB(255, 230, 227, 227), 
          width: 1, 
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),

      child: Column(
        children: [   
           
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: Color.fromARGB(255, 21, 107, 168),
                // color: Color.fromARGB(255, 2, 107, 183),
              ),
              child: const Center(
                child:AppText(
                  text: "Latest Results",
                  fontWeight: FontWeight.bold, 
                  fontSize: 18, 
                  color: Colors.white,
                )
              ),
            ),
          ),

          // gameweek number
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 10),
            child: AppText(
              text: widget.selectedGameweekMap['gameweek_number'] == null ? 'Gameweek' : 'Gameweek ${widget.selectedGameweekMap['gameweek_number']}',
              fontWeight: FontWeight.w400, 
              fontSize: 16, 
              color: Colors.black,
            )
          ),

          // date
          Container(
            margin: const EdgeInsets.only(bottom: 15, top: 10),
            child: AppText(
              // date format should be something like: Sat 12th Dec
              text: DateFormat('EEE d MMM yyyy').format(DateTime.parse(widget.selectedGameweekMap['gameweek_date'])),
              fontWeight: FontWeight.w300, 
              fontSize: 12, 
              color: Colors.black,
            )
          ),

          fixtures,      

          // view fixtures button
          // put arrow beside it
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(  
                color:  const Color.fromARGB(255, 230, 227, 227), 
                width: 1, 
                // rounded border

              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: widget.onPressed,
                  child: const AppText(
                    text: 'View all results',
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 10,
                )
              ],
            )
          )
          

          
        ]
      )
    );

  }
}