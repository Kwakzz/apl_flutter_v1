import 'package:apl/helper_classes/custom_list_tile.dart';
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
      height: 80.0 * widget.fixtures.length,
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
            return FixturesGraphicListTile(

              gameDetails: fixture,
                  
              homeTeam: homeTeam,

              awayTeam: awayTeam,
              
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
                color: Color.fromARGB(255, 21, 107, 168),
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
                    text: 'View all fixtures',
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