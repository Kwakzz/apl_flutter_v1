import 'package:apl/helper_classes/text.dart';
import 'package:flutter/material.dart';

class ScoreLineRow extends StatelessWidget {

  const ScoreLineRow (
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
              // if home team logo is null, then display the image_not_supported icon
              homeTeam['team_logo_url'] == null || homeTeam['team_logo_url'] == '' ? const Icon(Icons.image_not_supported, size: 13) :homeTeam['team_logo_url'],
              width: 30,
              height: 30,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Icon(
                  Icons.error, 
                  size: 18,
                );
              }
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
              // if away team logo is null, then display the image_not_supported icon
              awayTeam['team_logo_url'] == null || awayTeam['team_logo_url'] == '' ? const Icon(Icons.image_not_supported, size: 13) :awayTeam['team_logo_url'],
              width: 30,
              height: 30,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Icon(
                  Icons.error, 
                  size: 18,
                );
              }
            ),
          ),

        ],
      )
    );
  }
  
}


class StartTimeRow extends StatelessWidget {

  const StartTimeRow (
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
              // if home team logo is null, then display the image_not_supported icon
              homeTeam['team_logo_url'] == null || homeTeam['team_logo_url'] == '' ? const Icon(Icons.image_not_supported, size: 13) :homeTeam['team_logo_url'],
              width: 30,
              height: 30,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Icon(
                  Icons.error, 
                  size: 18,
                );
              }
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
              // if away team logo is null, then display the image_not_supported icon
              awayTeam['team_logo_url'] == null || awayTeam['team_logo_url'] == '' ? const Icon(Icons.image_not_supported, size: 13) :awayTeam['team_logo_url'],
              width: 30,
              height: 30,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Icon(
                  Icons.error, 
                  size: 18,
                );
              }
            ),
          ),

        ],
      )
    );
  }
  
}


