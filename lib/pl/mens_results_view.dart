import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:apl/requests/competitions/get_mens_comps_req.dart';
import 'package:apl/requests/games/get_season_comp_fixtures_req.dart';
import 'package:apl/requests/goal/get_goals_by_season_and_comp_req.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:apl/requests/teams/get_teams_req.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'game_details.dart';



class MensResultsView extends StatefulWidget {
  const MensResultsView(
    {
      super.key,

    }
  );


  @override
  _MensResultsViewState createState() => _MensResultsViewState();
}

class _MensResultsViewState extends State<MensResultsView> {

  List<Map<String, dynamic>> seasonsMap = [];

  List<Map<String, dynamic>> compsMap = [];

  List<Map<String, dynamic>> compFixtures = [];

  List<Map<String, dynamic>> teams = [];

  List<Map<String, dynamic>> goals = [];

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
    getMensCompetitions().then((result) {
      setState(() {
        compsMap = result;
      });

      // set selected comp map to the first comp map
      if (compsMap.isNotEmpty) {
        selectedCompMap = compsMap.first;
      } else {
        selectedCompMap = {};
      }

      // load the fixtures of the selected season and competition
      try{
        getSeasonCompFixtures(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
          setState(() {
            compFixtures = result;
            // if gameweek date has passed, don't display the fixture
            compFixtures.removeWhere((fixture) => DateTime.parse(fixture['gameweek_date']).isAfter(DateTime.now()));
            // sort the fixtures by gameweek date
            compFixtures.sort((a, b) => a['gameweek_date'].compareTo(b['gameweek_date']));

          });
        });
      }

      catch(e){
        return e;
      }

      // get goals scored in the selected season and competition
      try {
        getGoalsBySeasonAndCompetition(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
          setState(() {
            goals = result;
            
          });
        });
      }

      catch(e){
        return e;

      }

          
    });

    // get teams when the page loads
    // they are needed to display the team name instead of the team id so that we can
    // have something like "Elite vs Kasanoma" instead of "1 vs 2"
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

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
          getSeasonCompFixtures(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
            setState(() {
              compFixtures = result;
              // if gameweek date has passed, don't display the fixture
              compFixtures.removeWhere((fixture) => DateTime.parse(fixture['gameweek_date']).isAfter(DateTime.now()));
              // sort the fixtures by gameweek date
              compFixtures.sort((a, b) => a['gameweek_date'].compareTo(b['gameweek_date']));
              // get goals scored in the selected season and competition
              getGoalsBySeasonAndCompetition(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
                setState(() {
                  goals = result;
                });
              });

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

           // load the fixtures of the selected season and competition
          getSeasonCompFixtures(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
            setState(() {
              compFixtures = result;
              // if gameweek date has passed, don't display the fixture
              compFixtures.removeWhere((fixture) => DateTime.parse(fixture['gameweek_date']).isAfter(DateTime.now()));
              // sort the fixtures by gameweek date
              compFixtures.sort((a, b) => a['gameweek_date'].compareTo(b['gameweek_date']));

              // get goals scored in the selected season and competition
              getGoalsBySeasonAndCompetition(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
                setState(() {
                  goals = result;
                });
              });
            });
          });
        }
        );
      }
    );


    return Scaffold(
      body: Column(
        children: [
          seasonsDropDown,
          compsDropDown,
          Expanded(
            child: ListView.builder(
              itemCount: compFixtures.length,
              itemBuilder: (context, index) {
                final fixture = compFixtures[index];
                final gameweekDate = fixture['gameweek_date'];
                final formattedDate = DateFormat('EEE d MMM yyyy').format(DateTime.parse(gameweekDate));
                final homeTeam = teams.firstWhere((team) => team['team_id'] == fixture['home_id']);
                final awayTeam = teams.firstWhere((team) => team['team_id'] == fixture['away_id']);

                // Find the goals which match the fixture id and home team id to get the number of goals scored by the home team
                final homeGoals = goals.where((goal) => goal['game_id'] == fixture['game_id'] && goal['team_id'] == fixture['home_id']).toList();
                final homeTeamScore = homeGoals.length;

                // Find the goals which match the fixture id and away team id to get the number of goals scored by the away team
                final awayGoals = goals.where((goal) => goal['game_id'] == fixture['game_id'] && goal['team_id'] == fixture['away_id']).toList();
                final awayTeamScore = awayGoals.length;


                if (index == 0 || compFixtures[index - 1]['gameweek_date'] != gameweekDate) {
                  // Display the gameweek date heading if it's the first fixture or different from the previous one
                  return Column(
                    children: [
                      Container(
                        decoration:const BoxDecoration(
                          color:  Color.fromARGB(255, 243, 241, 241),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Center(
                          child: AppText(
                            text: formattedDate,
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          )
                        )
                      ),
                      ResultsGraphicListTile(
                        homeTeam: homeTeam,
                        homeTeamScore: homeTeamScore,
                        awayTeam: awayTeam,
                        awayTeamScore: awayTeamScore,
                        gameDetails: fixture,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameDetails(
                                pageName: '${homeTeam['team_name_abbrev']} vs ${awayTeam['team_name_abbrev']}',
                                gameDetails: fixture,
                                homeTeam: homeTeam,
                                awayTeam: awayTeam,
                                gameweekDetails: fixture,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  // If it's the same gameweek_date, display only the fixture details
                  return ResultsGraphicListTile(
                    homeTeam: homeTeam,
                    homeTeamScore: homeTeamScore,
                    awayTeam: awayTeam,
                    awayTeamScore: awayTeamScore,
                    gameDetails: fixture,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameDetails(
                            pageName: '${homeTeam['team_name_abbrev']} vs ${awayTeam['team_name_abbrev']}',
                            gameDetails: fixture,
                            homeTeam: homeTeam,
                            awayTeam: awayTeam,
                            gameweekDetails: fixture,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

  }
}