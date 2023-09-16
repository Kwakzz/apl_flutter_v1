
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/requests/games/get_no_of_games_played_by_mens_team_req.dart';
import 'package:apl/requests/goal/get_mens_team_draws_req.dart';
import 'package:apl/requests/goal/get_mens_team_total_wins_req.dart';
import 'package:apl/requests/goal/get_team_goals_req.dart';
import 'package:apl/requests/goal/get_total_goals_conceded_by_mens_team_req.dart';
import 'package:apl/requests/goal/get_womens_team_losses_req.dart';
import 'package:apl/requests/goal/get_womens_team_wins_req.dart';
import 'package:flutter/material.dart';
import '../helper_classes/text.dart';
import '../requests/games/get_no_of_games_played_by_womens_team_req.dart';
import '../requests/goal/get_mens_team_total_losses_req.dart';
import '../requests/goal/get_mens_team_goals_req.dart';
import '../requests/goal/get_total_goals_conceded_by_womens_team_req.dart';
import '../requests/goal/get_womens_team_draws_req.dart';
import '../requests/goal/get_womens_team_goals_req.dart';


class TeamStats extends StatefulWidget {
  const TeamStats(
    {
      super.key,
      required this.team
    }
  );

  final Map<String, dynamic> team;

  @override
  _TeamStatsState createState() => _TeamStatsState();
}

class _TeamStatsState extends State<TeamStats> {

  int mensNoOfGoals = 0;
  int womensNoOfGoals = 0;

  int mensNoOfGoalsConceded = 0;
  int womensNoOfGoalsConceded = 0;

  int mensNoOfWins = 0;
  int womensNoOfWins = 0;

  int mensNoOfDraws = 0;
  int womensNoOfDraws = 0;

  int mensNoOfLosses = 0;
  int womensNoOfLosses = 0;

  int mensNoOfGamesPlayed = 0;
  int womensNoOfGamesPlayed = 0;

  @override
  /// This function is called when the page loads.
  void initState() {
    super.initState();


    getMensTeamTotalNoOfGoals(widget.team['team_id']).then((result) {
      setState(() {
        mensNoOfGoals = result['total_goals'];
      });
    });

    getWomensTeamTotalNoOfGoals(widget.team['team_id']).then((result) {
      setState(() {
        womensNoOfGoals = result['total_goals'];
      });
    });

    getTotalGoalsConcededByMensTeam(widget.team['team_id']).then((result) {
      setState(() {
        mensNoOfGoalsConceded = result['total_goals_conceded'];
      });
    });

    getTotalGoalsConcededByWomensTeam(widget.team['team_id']).then((result) {
      setState(() {
        womensNoOfGoalsConceded = result['total_goals_conceded'];
      });
    });

    getMensTeamTotalNoOfWins(widget.team['team_id']).then((result) {
      setState(() {
        mensNoOfWins = result['no_of_wins'];
      });
    });

    getWomensTeamTotalNoOfWins(widget.team['team_id']).then((result) {
      try {
        setState(() {
          womensNoOfWins = result['no_of_wins'];
        });
      } catch (e) {
        return;
      }    
    });

    getMensTeamTotalNoOfLosses(widget.team['team_id']).then((result) {
      setState(() {
        mensNoOfLosses = result['no_of_losses'];
      });
    });

    getWomensTeamTotalNoOfLosses(widget.team['team_id']).then((result) {
      try {
        setState(() {
          womensNoOfLosses = result['no_of_losses'];
        });
      } catch (e) {
        return;
      }   
    });

    getMensTeamTotalNoOfDraws(widget.team['team_id']).then((result) {
       try {
        setState(() {
          womensNoOfDraws = result['no_of_draws'];
        });
      } catch (e) {
        return;
      }  
    });

    getWomensTeamTotalNoOfDraws(widget.team['team_id']).then((result) {
      setState(() {
        womensNoOfDraws = result['no_of_draws'];
      });
    });

    getNoOfGamesPlayedByMensTeam(widget.team['team_id']).then((result) {
      setState(() {
        mensNoOfGamesPlayed = result['no_of_games_played'];
      });
    });

    getNoOfGamesPlayedByWomensTeam(widget.team['team_id']).then((result) {
      try{
        setState(() {
          womensNoOfGamesPlayed = result['no_of_games_played'];
        });
      } catch (e) {
        return;
      }
    });

  }

  @override
  Widget build(BuildContext context) {




      return Scaffold(
        body: ListView(

          children: [

            // MEN
            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.only(left: 20),
              child: const AppText(
                text: 'All Time Stats (Men)',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )
            ),

            const SizedBox(height: 20),

            // Goals
            PlayerDetailListTile(
              heading: 'Goals',
              value: mensNoOfGoals.toString(),
            ),

            // Goals Conceded
            PlayerDetailListTile(
              heading: 'Goals Conceded',
              value: mensNoOfGoalsConceded.toString(),
            ),

            // Wins
            PlayerDetailListTile(
              heading: 'Wins',
              value: mensNoOfWins.toString(),
            ),

            // Draws
            PlayerDetailListTile(
              heading: 'Draws',
              value: mensNoOfDraws.toString(),
            ),

            // Losses
            PlayerDetailListTile(
              heading: 'Losses',
              value: mensNoOfLosses.toString(),
            ),


            // WOMEN
             const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.only(left: 20),
              child: const AppText(
                text: 'All Time Stats (Women)',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )
            ),

            const SizedBox(height: 20),

            // Goals
            PlayerDetailListTile(
              heading: 'Goals',
              value: womensNoOfGoals.toString(),
            ),

            // Goals Conceded
            PlayerDetailListTile(
              heading: 'Goals Conceded',
              value: womensNoOfGoalsConceded.toString(),
            ),

            // Wins
            PlayerDetailListTile(
              heading: 'Wins',
              value: womensNoOfWins.toString(),
            ),

            // Draws
            PlayerDetailListTile(
              heading: 'Draws',
              value: womensNoOfDraws.toString(),
            ),

            // Losses
            PlayerDetailListTile(
              heading: 'Losses',
              value: womensNoOfLosses.toString(),
            ),


            
          ]
        )



      );
  }

}


