import 'package:apl/pl/club_details.dart';
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:flutter/material.dart';
import '../../requests/teams/get_teams_req.dart';


class Clubs extends StatefulWidget {
  const Clubs(
    {
      super.key,
      required this.pageName
    }
  );

  final String pageName;

  @override
  _ClubsState createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {

  List<Map<String, dynamic>> teams = [];
  List<Map<String, dynamic>> filteredTeams = [];


  @override
  /// This function is called when the page loads.
  /// It calls the function to get the teams.
  /// It also sets the filteredTeams list to the teams list.
  void initState() {
    super.initState();

    // Call the function to get the teams when the page loads
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      // app bar
      appBar: CustomAppbar(
        pageName: widget.pageName,
        icon: const Icon(Icons.arrow_back),
        prevContext: context,
      ),

      body: Column(
        children: [
          // List of teams
          Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
          
                
                return ClubListTile(
                  teamName: team['team_name'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClubDetails(
                          team: team,
                        ),
                      ),
                    );
                  },
                  teamLogoURL: team['team_logo_url'],
                );
              },
            )
          ),
        ]
      )
    );
  }
}