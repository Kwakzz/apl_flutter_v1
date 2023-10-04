import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/pl/game_details.dart';
import 'package:flutter/material.dart';

import 'helper_classes/text.dart';



class LatestResults extends StatefulWidget {
  const LatestResults(
    {
      super.key,
      required this.fixtures,
      required this.teams,
      required this.selectedGameweekMap,
      required this.onPressed
    }
  );

  final List<Map<String, dynamic>> fixtures;
  final List<Map<String, dynamic>> teams;
  final Map<String, dynamic> selectedGameweekMap;
  final Function () ? onPressed;

  


  @override
  _LatestResultsState createState() => _LatestResultsState();
}

class _LatestResultsState extends State<LatestResults> {

  

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

          try {
            return FixturesListTile(
                  
              title: '${homeTeam['team_name']} vs ${awayTeam['team_name']}',
              // display competition name and stage
              // if stage is null, then display the text ''
              subtitle: fixture['stage_name'] == null ? '${fixture['competition_name']}' : '${fixture['competition_name']} - ${fixture['stage_name']}',
              
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

    if (widget.fixtures.isEmpty) {
      return Container();
    }
    
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration:  BoxDecoration(
        color: Colors.white,
        
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
                color: Color.fromARGB(255, 2, 107, 183),
              ),
              child: 
              Center(
                child:AppText(
                  // if the gameweek number is null, then display the text ''
                  text: widget.selectedGameweekMap['gameweek_number'] == null ? 'Gameweek' : 'Gameweek ${widget.selectedGameweekMap['gameweek_number']}',
                  
                  fontWeight: FontWeight.bold, 
                  fontSize: 18, 
                  color: Colors.white,
                )
              ),
            ),
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