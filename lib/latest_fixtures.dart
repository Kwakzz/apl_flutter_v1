import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/pl/fixtures.dart';
import 'package:apl/pl/game_details.dart';
import 'package:flutter/material.dart';

import 'helper_classes/text.dart';



class LatestFixtures extends StatefulWidget {
  const LatestFixtures(
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
  _LatestFixturesState createState() => _LatestFixturesState();
}

class _LatestFixturesState extends State<LatestFixtures> {



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

    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
           BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ]
      ),
      child: Column(
        children: [    
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 2, 107, 183),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width, 
              ),
              child: AppText(
                // if the gameweek number is null, then display the text ''
                text: widget.selectedGameweekMap['gameweek_number'] == null ? 'Gameweek' : 'Gameweek ${widget.selectedGameweekMap['gameweek_number']}',
                
                fontWeight: FontWeight.bold, 
                fontSize: 15, 
                color: Colors.white,
              ),
            ),
          ),

          fixtures,

          

          // view fixtures button
          TextButton(
            onPressed: widget.onPressed,
            child: const AppText(
              text: 'View all fixtures',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color.fromARGB(255, 2, 107, 183),
            ),
          )
        ]
      )
    );

  }
}