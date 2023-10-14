import 'package:apl/admin_pages/news/news_items.dart';
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/lastest_news_item.dart';
import 'package:apl/latest_fixtures.dart';
import 'package:apl/latest_results.dart';
import 'package:apl/latest_tables.dart';
import 'package:apl/pl/fixtures.dart';
import 'package:apl/pl/news.dart';
import 'package:apl/pl/results.dart';
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
import 'package:flutter/scheduler.dart';

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
  

  Future <List<dynamic>> fetchData() async {

    // FETCH NEWS ITEMS AND SET THE FIRST NEWS ITEM
    newsItems = await getAllNewsItems();
    newsItem = newsItems.first;


    // FETCH SEASONS AND SET THE SELECTED SEASON
    seasonsMap = await getSeasons();
    selectedSeasonMap = seasonsMap.first;

    // IF THE SELECTED SEASON MAP IS EMPTY ALL THE OTHER MAPS WILL BE EMPTY, SO DON'T FETCH THEM   
    if (selectedSeasonMap.isNotEmpty) {

      // FETCH GAMEWEEKS FOR THE SELECTED SEASON
      gameweeksMap = await getSeasonGameweeks(selectedSeasonMap['season_id']);
        


      // FETCH THE UPCOMING GAMEWEEK AND THE MOST RECENT GAMEWEEK
      if (gameweeksMap.isNotEmpty) {

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
                  
      }
  

      // FETCH THE NEXT SET OF FIXTURES (UNPLAYED GAMES)
      if (upcomingGameweekMap.isNotEmpty) {
        upcomingGameweekFixtures = await getGameweekGames(upcomingGameweekMap['gameweek_id']);
      }   


      // FETCH THE MOST RECENT SET OF FIXTURES (PLAYED GAMES) AND SET THE COMPETITION ID OF THE FIRST FIXTURE AS THE SELECTED COMPETITION ID
      if (mostRecentGameweekMap.isNotEmpty) {
        mostRecentGameweekFixtures = await getGameweekGames(mostRecentGameweekMap['gameweek_id']);
        selectedCompId = await mostRecentGameweekFixtures.first['competition_id'];
      }


      // DISPLAY THE STANDINGS FOR THE SELECTED COMPETITION
      if (selectedCompId != 0) {

        // Fetch standings for the selected season and competition
        standingsTeams = await getSeasonCompStandingsWithTeams(
          selectedSeasonMap['season_id'], selectedCompId
        );

        if (standingsTeams.isNotEmpty) {
          // Update standings
          for (var team in standingsTeams) {
            int teamId = team['team_id'];
            await updateStandings(
              updateStandingsTeamJson(
                teamId, 
                selectedCompId, 
                selectedSeasonMap['season_id']
              )
            );


          }
        }
      }

      // FETCH TEAMS 
      // they are needed to display the team name instead of the team id so that we can
      // have something like "Elite vs Kasanoma" instead of "1 vs 2"
      teams = await getTeams();

      return ([
        newsItem, 
        upcomingGameweekMap, 
        mostRecentGameweekMap, 
        upcomingGameweekFixtures, 
        mostRecentGameweekFixtures, 
        selectedCompId, 
        standingsTeams, 
        teams
      ]);
  
    }

    return [newsItem];

  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 

  @override
  Widget build(BuildContext context) {

    List<Widget> leagueTables = [];
    
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: const APLAppBar(),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }

            if (snapshot.hasError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: AppText(
                      text: 'An error occurred. Please try again later',
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    )
                  ),
                );
              }
              );

              // Return a fallback UI, or simply return an empty container.
              return Container();

            }

            final List<dynamic> data = snapshot.data as List<dynamic>;

            if (data.length == 1) {
              newsItem = data[0];
            }

            else {

              newsItem = data[0];
              upcomingGameweekMap = data[1];
              mostRecentGameweekMap = data[2];
              upcomingGameweekFixtures = data[3];
              mostRecentGameweekFixtures = data[4];
              selectedCompId = data[5];
              standingsTeams = data[6];
              teams = data[7];


              // check the standingsTeam list. if there's any standingsTeam with a different standings_id, create a separate list for that
              // this is to create a separate table for each standings_id
              Map<int, List<Map<String, dynamic>>> groupedStandings = {};

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
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          color: Color.fromARGB(255, 21, 107, 168),
                          // color: Color.fromARGB(255, 2, 107, 183),
                        ),
                        child: Center(
                          child: AppText(
                            text: '${groupedStandings[standingsId]![0]['competition_name']} ${groupedStandings[standingsId]![0]['standings_name']} (${groupedStandings[standingsId]![0]['gender']})',
                            fontWeight: FontWeight.bold, 
                            fontSize: 15, 
                            color: Colors.white
                          ),
                        )
                      ),
                      LatestLeagueTable(standingsTeams: teams),         
                      const SizedBox(height: 16), 
                    ],
                  );
                })
                .toList();
              }

              
            }

        
            return ListView(

              children: [

                if (newsItem.isNotEmpty)
                  
                  // latest news
                  LatestNews(
                    newsItem: newsItem,
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewNewsItem(
                            newsItemMap: newsItem,
                          )
                        ),
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
                    selectedSeasonId: selectedSeasonMap['season_id'],
                    selectedCompId: selectedCompId,
                  ),
                

                // tables
                if (standingsTeams.isNotEmpty)
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
                  ),

                
                // Latest news section. Start from second item in the list because the first item is the latest news item. First check if the newsItems list is not empty and then check if the length is greater than 1
                if (newsItems.isNotEmpty && newsItems.length > 5)
                  Column(
                    children: [

                      // latest news 
                      Container(
                        margin: const EdgeInsets.only(left: 15, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: 
                        const AppText(
                          text: 'Latest News',
                          fontWeight: FontWeight.bold, 
                          fontSize: 21, 
                          color: Colors.black
                        ),
                      ),

                      // list of news items
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return LatestNewsListTile(
                            newsMap: newsItems[index + 1],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewNewsItem(
                                    newsItemMap: newsItems[index + 1],
                                  )
                                ),
                              );
                            },
                          
                          );
                        }
                      ),


                      const SizedBox(height: 10), 
                      
                      // view all news button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const News(
                                  pageName: 'News',
                                )),
                              );
                            },
                            child: const AppText(
                              text: 'View all news',
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
                    ],
                  ),
                
              ]          

            );
          }
        ),
        backgroundColor: Colors.white,
      )
    );
      
  }
}