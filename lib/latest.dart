import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/lastest_news_item.dart';
import 'package:apl/latest_fixtures.dart';
import 'package:apl/pl/fixtures.dart';
import 'package:apl/pl/tables.dart';
import 'package:apl/pl/view_news_item.dart';
import 'package:apl/requests/games/get_gw_games_req.dart';
import 'package:apl/requests/gameweeks/get_season_gw_req.dart';
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
  Map <String, dynamic> selectedGameweekMap = {};

  List<Map <String, dynamic>> nextFixtures = [];

  int selectedCompId = 0;

  List<Map<String, dynamic>> standingsTeams = [];

  List<Map<String, dynamic>> teams = [];
  

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

            // If gameweek date has passed, remove that gameweek
            if (gameweeksMap.isNotEmpty) {
              gameweeksMap.removeWhere((fixture) =>
                DateTime.parse(fixture['gameweek_date']).isBefore(DateTime.now()));
            }

            // Set the selected gameweek to the last gameweek (next gameweek)
            if (gameweeksMap.isNotEmpty) {
              selectedGameweekMap = gameweeksMap.last;
            } else {
              selectedGameweekMap = {}; 
            }

            // Fetch the next set of fixtures (unplayed games)
            try {
              getGameweekGames(selectedGameweekMap['gameweek_id']).then((result) {
                setState(() {
                  try {
                    nextFixtures = result;
                  } catch (e) {
                    return;
                  }

                  // Get the competition id of the first fixture
                  selectedCompId = nextFixtures[0]['competition_id'];

                  // Fetch standings for the selected season and competition
                  try {

                    getSeasonCompStandingsWithTeams(
                            selectedSeasonMap['season_id'], selectedCompId)
                        .then((result) {
                      setState(() {
                        standingsTeams = result;
                        // Update standings
                        for (var team in standingsTeams) {
                          int teamId = team['team_id'];
                          updateStandings(updateStandingsTeamJson(
                              teamId, selectedCompId, selectedSeasonMap['season_id']));
                        }
                      });
                    });
                  } catch (e) {
                    return;
                  }
                });
              });
            } catch (e) {
              return;
            }
          });
        });
      }
    });

    // Fetch teams when the page loads
    // they are needed to display the team name instead of the team id so that we can
    // have something like "Elite vs Kasanoma" instead of "1 vs 2"
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

  });

  }


  @override
  Widget build(BuildContext context) {

    // check the standingsTeam list. if there's any standingsTeam with a different standings_id, create a separate list for that
    // this is to create a separate table for each standings_id
    Map<int, List<Map<String, dynamic>>> groupedStandings = {};

    // men's standings
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 2, 107, 183),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )
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


    return  MaterialApp(
      home: Scaffold(
        appBar: const APLAppBar(),
        body: ListView(

          children: [

            // latest news
            Container(
              margin: const EdgeInsets.only( bottom: 16),
              color: const Color.fromARGB(255, 0, 53, 91),
              child: LatestNews(
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
            ),



            // fixtures
            // Check if nextFixtures is empty before rendering fixtures
            if (nextFixtures.isEmpty)
              const Center(
                child: AppText(
                  text: "No fixtures available", 
                  fontWeight: FontWeight.w300, 
                  fontSize: 13, 
                  color: Colors.black
                )
              )
            else
            LatestFixtures(
              fixtures: nextFixtures, 
              teams: teams,
              selectedGameweekMap: selectedGameweekMap,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Fixtures(
                    pageName: 'Fixtures',
                  )),
                );
              }
            ),

            // tables
            Container(
                // width
     
               decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 3),
                  )
                ]
              ),
              margin: const EdgeInsets.only(top:16, bottom: 16, left: 10, right: 10),
              child: Column(
                children: [
                  // league tables
                  // Check if gameweeksMap is empty before rendering league tables
                  if (gameweeksMap.isEmpty)
                    const Center(
                      child: AppText(
                        text: "No tables available", 
                        fontWeight: FontWeight.w300, 
                        fontSize: 13, 
                        color: Colors.black
                      )
                    )
                  else if (leagueTables.isNotEmpty)
                    ...leagueTables,

                  // "View Tables" button
                  // if gameweeksMap is empty, don't show the button
                  if (gameweeksMap.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Tables(
                            pageName: 'Tables',
                          )),
                        );
                      },
                      child: const AppText(
                        text: 'View all tables',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color.fromARGB(255, 2, 107, 183),
                      ),
                    )
                ],
              ),
            ),
            
          ]          

        ),
        backgroundColor: Colors.white,
      )
    );
  }
}