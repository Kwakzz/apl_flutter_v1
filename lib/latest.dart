import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/lastest_news_item.dart';
import 'package:apl/latest_fixtures.dart';
import 'package:apl/latest_results.dart';
import 'package:apl/latest_tables.dart';
import 'package:apl/pl/fixtures.dart';
import 'package:apl/pl/results.dart';
import 'package:apl/pl/tables.dart';
import 'package:apl/pl/view_news_item.dart';
import 'package:apl/requests/games/get_gw_games_req.dart';
import 'package:apl/requests/gameweeks/get_season_gw_req.dart';
import 'package:apl/requests/goal/get_goals_by_season_and_comp_req.dart';
import 'package:apl/requests/news_item/get_all_news_items_req.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:apl/requests/standings/get_season_comp_standings_with_teams_req.dart';
import 'package:apl/requests/standings/update_standings_team_req.dart';
import 'package:apl/requests/teams/get_teams_req.dart';
import 'package:flutter/material.dart';

import 'helper_classes/my_data_table.dart';
import 'helper_functions/convert_to_json.dart';




class Latest extends StatefulWidget {
  const Latest({super.key});

  @override
  _LatestState createState() => _LatestState();
}



class _LatestState extends State<Latest> {

  List<Map<String, dynamic>> newsItems = [];
  Map <String, dynamic> newsItem = {};

  List<Map<String, dynamic>> seasonsMap = [];
  // map of selected season
  Map <String, dynamic> selectedSeasonMap = {};

  List<Map<String, dynamic>> gameweeksMap = [];
  Map <String, dynamic> upcomingGameweekMap = {};

  Map <String, dynamic> mostRecentGameweekMap = {};

  List<Map <String, dynamic>> upcomingGameweekFixtures = [];

  List <Map<String, dynamic>> mostRecentGameweekFixtures = [];

  int selectedCompId = 0;

  List<Map<String, dynamic>> standingsTeams = [];

  List<Map<String, dynamic>> teams = [];

  List<Map<String, dynamic>> goals = [];
  

  @override
  void initState() {
    super.initState();

    // Fetch news items and set the first news item
    getAllNewsItems().then((result) {
      setState(() {
        newsItems = result;
        if (newsItems.isNotEmpty) {
          newsItem = newsItems.first;
        } else {
          newsItem = {};
        }
      });
    });

    // Fetch seasons and set the selected season
    getSeasons().then((result) {
      setState(() {

        // handle null result
        if (result == []) {
          return;
        }
        seasonsMap = result;

        if (seasonsMap.isNotEmpty) {
          // seasons are already sorted in descending order of season_id, so the first season is the most recent season
          selectedSeasonMap = seasonsMap.first;
        } else {
          selectedSeasonMap = {};
        }

      // Fetch gameweeks for the selected season
      // don't fetch gameweeks if the selected season is empty
      if (selectedSeasonMap.isNotEmpty) {
        getSeasonGameweeks(selectedSeasonMap['season_id']).then((result) {
          setState(() {

            // handle null result
            if (result == []) {
              return;
            }
            gameweeksMap = result;

            if (gameweeksMap.isNotEmpty) {

              setState(() {

                // get today's date
                DateTime today = DateTime.now();

                // get next gameweek. Among the list of gameweeks, it's the gameweek whose date is greater than today's date or equal to today's date. For the gameweeks whose date is greater than today's date, the one with the nearest date is selected. The gameweeks are already sorted in descending order of date, so the first gameweek whose date is greater than today's date is the next gameweek
                if (gameweeksMap.firstWhere((gameweek) => DateTime.parse(gameweek['gameweek_date']).isAfter(today) || DateTime.parse(gameweek['gameweek_date']).isAtSameMomentAs(today) ).isNotEmpty) {

                  Map<String, dynamic> nextGameweek = (gameweeksMap.firstWhere((gameweek) => DateTime.parse(gameweek['gameweek_date']).isAfter(today)));
                  upcomingGameweekMap = nextGameweek;

                }
    
                  
                // get the most recent gameweek to display the most recent results. this gameweek is the one whose date is less than today's date. For the gameweeks whose date is less than today's date, the one with the nearest date is selected. The gameweeks are already sorted in descending order of date, so the first gameweek whose date is less than today's date is the most recent gameweek
                if (gameweeksMap.firstWhere((gameweek) => DateTime.parse(gameweek['gameweek_date']).isBefore(today)).isNotEmpty) {

                  Map<String, dynamic> mostRecentGameweek = (gameweeksMap.firstWhere((gameweek) => DateTime.parse(gameweek['gameweek_date']).isBefore(today)));

                  mostRecentGameweekMap = mostRecentGameweek;
                }      
              
              });
            }

            // Fetch the next set of fixtures (unplayed games)
            if (upcomingGameweekMap.isNotEmpty) {
              getGameweekGames(upcomingGameweekMap['gameweek_id']).then((result) {
                setState(() {
                  upcomingGameweekFixtures = result;
                });
              });
            } 

            // Fetch the most recent set of fixtures (played games)
            if (mostRecentGameweekMap.isNotEmpty) {
              getGameweekGames(mostRecentGameweekMap['gameweek_id']).then((result) {
                setState(() {
                  mostRecentGameweekFixtures = result;
                });
              });
            }
               

            // get the competition whose table you want to display. if there are any upcoming fixtures, display the table for the competition of the first fixture. if there are no upcoming fixtures, display the table for the competition of the first fixture in the most recent gameweek
            if (mostRecentGameweekFixtures.isNotEmpty) {
              setState(() {
                selectedCompId = mostRecentGameweekFixtures[0]['competition_id'];
              });
            }
            else if (upcomingGameweekFixtures.isNotEmpty) {
              setState(() {
                selectedCompId = upcomingGameweekFixtures[0]['competition_id'];
              });
            }

            if (selectedCompId != 0) {

              // Fetch standings for the selected season and competition

              getSeasonCompStandingsWithTeams(
                selectedSeasonMap['season_id'], selectedCompId
              ).then((result) {
                setState(() {
                  standingsTeams = result;

                  if (standingsTeams.isEmpty) {
                    return;
                  }

                  // Update standings
                  for (var team in standingsTeams) {
                    int teamId = team['team_id'];
                    updateStandings(
                      updateStandingsTeamJson(
                        teamId, 
                        selectedCompId, 
                        selectedSeasonMap['season_id']
                      )
                    );
                  }
                });
              });

            }


          });
        });
     }});
    });
  

    // Fetch teams when the page loads
    // they are needed to display the team name instead of the team id so that we can
    // have something like "Elite vs Kasanoma" instead of "1 vs 2"
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

    // Fetch goals when the page loads
    // they are needed to display the number of goals scored by each team
    // display them if season is not empty and selectedCompId is not 0
    if (selectedSeasonMap.isNotEmpty && selectedCompId != 0) {
      getGoalsBySeasonAndCompetition(selectedSeasonMap['season_id'], selectedCompId).then((result) {
        setState(() {
          goals = result;
        });
      });
    }

  }

  


  @override
  Widget build(BuildContext context) {

    print (goals);

    // check the standingsTeam list. if there's any standingsTeam with a different standings_id, create a separate list for that
    // this is to create a separate table for each standings_id
    Map<int, List<Map<String, dynamic>>> groupedStandings = {};
    List<Widget> leagueTables = [];

    if (standingsTeams.isNotEmpty) {

      // men's standings
      for (var team in standingsTeams) {
        int standingsId = team['standings_id'];

        if (!groupedStandings.containsKey(standingsId)) {
          groupedStandings[standingsId] = [];
        }

        groupedStandings[standingsId]!.add(team);
      }

      leagueTables = groupedStandings.entries
      .map<Widget>((entry) {
        int standingsId = entry.key;
        List<Map<String, dynamic>> teams = entry.value;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 2, 107, 183),
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(16),
                //   topRight: Radius.circular(16),
                // )
              ),
              child: AppText(
                text: '${groupedStandings[standingsId]![0]['competition_name']} ${groupedStandings[standingsId]![0]['standings_name']} (${groupedStandings[standingsId]![0]['gender']})',
                fontWeight: FontWeight.bold, 
                fontSize: 15, 
                color: Colors.white
              ),
            ),
            LatestLeagueTable(standingsTeams: teams),         
            const SizedBox(height: 16), 
          ],
        );
      })
      .toList();
    }

    if (selectedSeasonMap.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }


    return  MaterialApp(
      home: Scaffold(
        appBar: const APLAppBar(),
        body: ListView(

          children: [

            // latest news
            LatestNews(
                newsItem: newsItem,
                onTapped: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewNewsItem(
                      newsItemMap: newsItem,
                    )),
                  );
                },
              ),
            

            const SizedBox(height: 35),
            
            if (upcomingGameweekMap.isNotEmpty) 
            // latest fixtures
              LatestFixtures(
                fixtures: upcomingGameweekFixtures, 
                teams: teams,
                selectedGameweekMap: upcomingGameweekMap,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Fixtures(
                      pageName: 'Fixtures',
                    )),
                  );
                }
              ),

            Container(
              height: 20,
            ),
            
            if (mostRecentGameweekMap.isNotEmpty)
              LatestResults(
                fixtures: mostRecentGameweekFixtures, 
                teams: teams,
                selectedGameweekMap: mostRecentGameweekMap,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Results(
                      pageName: 'Results',
                    )),
                  );
                },
                goals: goals,
              ),
             

            // tables
            LatestTables(
              leagueTables: leagueTables, 
              gameweeksMap: gameweeksMap, 
              viewAllTablesOnPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Tables(
                    pageName: 'Tables',
                  )),
                );
              },
            )
            
          ]          

        ),
        backgroundColor: Colors.white,
      )
    );
  }
}