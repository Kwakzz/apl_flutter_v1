import 'package:apl/admin_pages/games/team_lineup.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_appbar.dart';




class GameLineups extends StatefulWidget {
  const GameLineups(
    {
      super.key,
      required this.gameDetails,
      required this.homeTeam,
      required this.awayTeam,
    }
  );

  final Map<String, dynamic> gameDetails;
  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;

  @override
  _GameLineupsState createState() => _GameLineupsState();
}

class _GameLineupsState extends State<GameLineups> {


  Map<String, dynamic> homeTeamStartingXI = {};
  Map<String, dynamic> awayTeamStartingXI = {};
  



  @override
  Widget build(BuildContext context) {



     List <Widget> myTabs = [
      Tab(
        // name of team with home id
        text: widget.homeTeam['team_name']
      ),
      Tab(
        text: widget.awayTeam['team_name']
      ),
    ];
    
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppbarWithTabs(
            height: 60,
            pageName: "",
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: TabBarView(
            children: [
              TeamLineup(
                game: widget.gameDetails, 
                team: widget.homeTeam,
              ),
              TeamLineup(
                game: widget.gameDetails, 
                team: widget.awayTeam,
              )
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
    );
  }
}