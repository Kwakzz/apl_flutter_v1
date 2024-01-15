import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper_classes/my_data_table.dart';
import 'package:apl/helper/functions/convert_to_json.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:apl/requests/standings/get_season_comp_standings_with_teams_req.dart';
import 'package:apl/requests/standings/update_standings_team_req.dart';
import 'package:flutter/material.dart';

import '../helper/widgets/text.dart';
import '../requests/competitions/get_womens_comps_req.dart';


class WomensTables extends StatefulWidget {
  const WomensTables(
    {
      super.key,

    }
  );


  @override
  _WomensTablesState createState() => _WomensTablesState();
}

class _WomensTablesState extends State<WomensTables> {

  List<Map<String, dynamic>> seasonsMap = [];

  List<Map<String, dynamic>> compsMap = [];

  List<Map<String, dynamic>> standingsTeams = [];

  // map of selected season
  Map <String, dynamic> selectedSeasonMap = {};

  // map of the selected competition for the selected season
  Map <String, dynamic> selectedCompMap = {};
  

  @override
  /// This function is called when the page loads.
  /// It loads the seasons, competitions, fixtures and teams.
  void initState() {
    super.initState();

    // Call the function to get the seasons when the page loads
    getSeasons().then((result) {
      setState(() {
        seasonsMap = result;
        if (seasonsMap.isNotEmpty) {
          // set selected season map to the first season map
          // This is the most recent season
          selectedSeasonMap = seasonsMap.first;
        } else {
          selectedSeasonMap = {};
        }
      }
    );
    });

    // load all men's competitions
    getWomensCompetitions().then((result) {
      setState(() {
        compsMap = result;
      });

      // set selected comp map to the first comp map
      if (compsMap.isNotEmpty) {
        selectedCompMap = compsMap.first;
      } else {
        selectedCompMap = {};
      }

      try{
        getSeasonCompStandingsWithTeams(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
          setState(() {
            standingsTeams = result;
            // update standings
            for (var team in standingsTeams) {
              int teamId = team['team_id'];

              updateStandings(
                updateStandingsTeamJson(
                  teamId, 
                  selectedCompMap['competition_id'], 
                  selectedSeasonMap['season_id']
                )
              );
            }
          });
        });

        
      }

      catch(e){
        return e;
      }

          
    });

  }


  @override
  Widget build(BuildContext context) {

    // check the standingsTeam list. if there's any standingsTeam with a different standings_id, create a separate list for that
    // this is to create a separate table for each standings_id
    Map<int, List<Map<String, dynamic>>> groupedStandings = {};

    for (var team in standingsTeams) {
      int standingsId = team['standings_id'];

      if (!groupedStandings.containsKey(standingsId)) {
        groupedStandings[standingsId] = [];
      }

      groupedStandings[standingsId]!.add(team);
    }

    List<Widget> leagueTables = groupedStandings.entries
    .map<Widget>((entry) {
      int standingsId = entry.key;
      List<Map<String, dynamic>> teams = entry.value;

      return Column(
        children: [
          const SizedBox(height: 16), 
          AppText(
            text: '${groupedStandings[standingsId]![0]['standings_name']}',
            fontWeight: FontWeight.bold, 
            fontSize: 16, 
            color: Colors.black
          ),
          const SizedBox(height: 16), 
          LatestLeagueTable(standingsTeams: teams),         
          const SizedBox(height: 16), 
        ],
      );
    })
    .toList();


  


    // list of season names
    // will be used to display the season names in the dropdown menu
    final seasonNames = seasonsMap.map((season) => season['season_name'] as String).toList();

    // list of competition names
    // will be used to display the competition names in the dropdown menu
    final compNames = compsMap.map((comp) => comp['competition_name'] as String).toList();


    // season drop down menu
    MyDropdownFormField seasonsDropDown = MyDropdownFormField(
      items: seasonNames,
      selectedValue: selectedSeasonMap["season_name"],
      labelText: "Season",
      onChanged: (newValue) {
        setState(() {
          // set selected season map to the season map of the selected season
          // or else return an empty map if the season is not found
          selectedSeasonMap = seasonsMap.firstWhere(
            (season) => season["season_name"].toString() == newValue,
            orElse: () => {},
          );

          // load the fixtures of the selected season and competition
          getSeasonCompStandingsWithTeams(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
            setState(() {
              standingsTeams = result;
              // update standings
              for (var team in standingsTeams) {
                int teamId = team['team_id'];

                updateStandings(
                  updateStandingsTeamJson(
                    teamId, 
                    selectedCompMap['competition_id'], 
                    selectedSeasonMap['season_id']
                  )
                );
              }
            });

          });
        }
        );
      }
    );

    // competition drop down menu
    MyDropdownFormField compsDropDown = MyDropdownFormField(
      items: compNames,
      selectedValue: selectedCompMap["competition_name"],
      labelText: "Competition",
      onChanged: (newValue) {
        setState(() {
          // set selected comp map to the comp map of the selected comp
          // or else return an empty map if the comp is not found
          selectedCompMap = compsMap.firstWhere(
            (comp) => comp["competition_name"].toString() == newValue,
            orElse: () => {},
          );

           // load the top scorers of the selected season and competition
          getSeasonCompStandingsWithTeams(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
            setState(() {
              standingsTeams = result;
              // update standings
              for (var team in standingsTeams) {
                int teamId = team['team_id'];

                updateStandings(
                  updateStandingsTeamJson(
                    teamId, 
                    selectedCompMap['competition_id'], 
                    selectedSeasonMap['season_id']
                  )
                );
              }
            });
          });
        }
        );
      }
    );


    return Column(
        children: [
          seasonsDropDown,
          compsDropDown,

          leagueTables.isNotEmpty ? Expanded(
            child: ListView(
              children: leagueTables,
            ),
          ) : Container(),
          
        ],
    );

  }
}