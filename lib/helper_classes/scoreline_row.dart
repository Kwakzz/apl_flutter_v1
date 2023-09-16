import 'package:apl/helper_classes/text.dart';
import 'package:flutter/material.dart';

class ScoreLineRow extends StatelessWidget {

  ScoreLineRow (
    {
      super.key,
      required this.homeTeam,
      required this.awayTeam,
      required this.homeTeamGoals,
      required this.awayTeamGoals,
    }
  );

  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;
  final List<Map<String, dynamic>> homeTeamGoals;
  final List<Map<String, dynamic>> awayTeamGoals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10,),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          

          // Home team
          AppText(
            text: homeTeam['team_name_abbrev'],
            fontWeight: FontWeight.w400,
            fontSize: 16, 
            color: Colors.black,
          ),

          // home team logo
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Image.network(
              homeTeam['team_logo_url'],
              width: 30,
              height: 30,
            ),
          ),


          const Text("     "),


          AppText(
            text: '${homeTeamGoals.length} - ${awayTeamGoals.length}',
            fontWeight: FontWeight.bold,
            fontSize: 25, 
            color: Colors.black,
          ),

          const Text("     "),

          // away team
          AppText(
            text: awayTeam['team_name_abbrev'],
            fontWeight: FontWeight.w400,
            fontSize: 16, 
            color: Colors.black,
          ),

          // away team logo
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Image.network(
              awayTeam['team_logo_url'],
              width: 30,
              height: 30,
            ),
          ),

        ],
      )
    );
  }
  
}


class StartTimeRow extends StatelessWidget {

  StartTimeRow (
    {
      super.key,
      required this.homeTeam,
      required this.awayTeam,
      required this.gameDetails,
    }
  );

  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;
  final Map<String, dynamic> gameDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10,),
      color: Colors.grey[300], 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Home team
          AppText(
            text: homeTeam['team_name_abbrev'],
            fontWeight: FontWeight.w400,
            fontSize: 16, 
            color: Colors.black,
          ),

          // home team logo
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Image.network(
              homeTeam['team_logo_url'],
              width: 30,
              height: 30,
            ),
          ),



          const Text("     "),


           // Start time
            AppText(
              text: gameDetails['start_time'].toString().substring(0, 5),
              fontWeight: FontWeight.bold,
              fontSize: 25, 
              color: Colors.black,
            ),

          const Text("     "),

          // away team
          AppText(
            text: awayTeam['team_name_abbrev'],
            fontWeight: FontWeight.w400,
            fontSize: 16, 
            color: Colors.black,
          ),

          // away team logo
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Image.network(
              awayTeam['team_logo_url'],
              width: 30,
              height: 30,
            ),
          ),

        ],
      )
    );
  }
  
}


