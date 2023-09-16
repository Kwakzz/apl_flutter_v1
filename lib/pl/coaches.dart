
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/pl/view_coach.dart';
import 'package:apl/requests/coach/get_coaches_req.dart';
import 'package:flutter/material.dart';
import '../../requests/teams/get_teams_req.dart';
import '../../helper_classes/search_field.dart';
import '../helper_classes/custom_appbar.dart';


class Coaches extends StatefulWidget {
  const Coaches(
    {
      super.key,
      required this.pageName
    }
  );

  final String pageName;

  @override
  _CoachesState createState() => _CoachesState();
}

class _CoachesState extends State<Coaches> {

  List<Map<String, dynamic>> coaches = [];

  List<Map<String, dynamic>> teams = [];

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the fans, teams and positions.
  /// It also sets the filteredCoaches list to the coaches list.
  void initState() {
    super.initState();

    // Call the function to get the players when the page loads
    getCoaches().then((result) {
      setState(() {
        coaches = result;
        filteredCoaches = coaches;
      });
    });

    // Call the function to get the teams when the page loads
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

  }

  String searchQuery = '';

  // list of coaches for the search bar
  List<Map<String, dynamic>> filteredCoaches = [];

  /// This function is called when the search bar is used.
  void updateFilteredCoaches(String query) {
    filteredCoaches = coaches.where((player) {
      final fullName = '${player['fname']} ${player['lname']}'.toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();
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
          // Search bar
          SearchField(
            onChanged: (value) {
              setState(() {
                searchQuery = value!;
                updateFilteredCoaches(searchQuery);
              });
            },
            labelText: 'Search by name',
          ),


          // List of coaches
          Expanded(
            child: ListView.builder(
              itemCount: filteredCoaches.length,
              itemBuilder: (context, index) {
                final coach = filteredCoaches[index];
                final team = teams.firstWhere(
                  (team) => team['team_id'] == coach['team_id'],
                  orElse: () => {'team_name': "None"},
                );

                
                
                return PlayerListTile(
                  playerName: '${coach['fname']} ${coach['lname']}', 
                  teamName: team['team_name'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewCoach(
                          coachMap: coach,
                        ),
                      ),
                    );
                  }
                );
              }
            )
          ),
        ]
      )
    );
  }
}