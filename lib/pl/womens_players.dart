import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/pl/view_player.dart';
import 'package:apl/requests/players/get_womens_players_req.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import '../helper_classes/search_field.dart';
import '../requests/teams/get_teams_req.dart'; 


class WomensPlayers extends StatefulWidget {
  const WomensPlayers({super.key});

  @override
  _WomensPlayersState createState() => _WomensPlayersState();
}

class _WomensPlayersState extends State<WomensPlayers> {
  List<Map<String, dynamic>> players = [];
  List<Map<String, dynamic>> teams = [];
  List<Map<String, dynamic>> positions = [];
  String selectedCriteria = "Active";
  int isRetired = 0;
  String searchQuery = '';
  List<Map<String, dynamic>> filteredPlayers = [];

  // StreamController for search queries
  StreamController<String> searchQueryController = StreamController<String>();

  @override
  void initState() {
    super.initState();
    // Initialize the StreamController here.
    searchQueryController = StreamController<String>.broadcast();

    // Listen for changes in the search query and update filteredPlayers
    searchQueryController.stream.listen((query) {
      updateFilteredPlayersForSearch(query);
    });
  }

  Future<List<dynamic>> fetchData() async {
    // Call the function to get the male players when the page loads
    players = await getWomensPlayers();

    // Call the function to get the teams when the page loads
    teams = await getTeams();

    // Initialize filteredPlayers here.
    filterPlayersForDropDown();

    return [players, teams];
  }

  void filterPlayersForDropDown() {
    if (selectedCriteria == "Active") {
      filteredPlayers = players.where((player) => player['is_retired'] == 0).toList();
      isRetired = 0;
    } else if (selectedCriteria == "Retired") {
      filteredPlayers = players.where((player) => player['is_retired'] == 1).toList();
      isRetired = 1;
    }
  }

  void updateFilteredPlayersForSearch(String query) {
    filteredPlayers = players.where((player) {
      final fullName = '${player['fname']} ${player['lname']}'.toLowerCase();
      final meetsCriteria = player['is_retired'] == isRetired;
      return fullName.contains(query.toLowerCase()) && meetsCriteria;
    }).toList();
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    
    // Dispose the StreamController when it's no longer needed.
    searchQueryController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> playerCriteria = ["Active", "Retired"];

    MyDropdownFormField playerCriteriaDropDown = MyDropdownFormField(
      items: playerCriteria,
      selectedValue: selectedCriteria,
      labelText: "Player Criteria",
      onChanged: (newValue) {
        setState(() {
          selectedCriteria = newValue!;
          filterPlayersForDropDown();
        });
      },
    );

    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: AppText(
                  text: 'An error occurred. Please try again later',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            );
          });
          // Return a fallback UI, or simply return an empty container.
          return Container();
        }

        List<dynamic> data = snapshot.data as List<dynamic>;
        players = data[0];
        teams = data[1];

        return Scaffold(
          body: Column(
            children: [
              // player criteria dropdown
              playerCriteriaDropDown,

              // Search bar
              SearchFieldWithController(
                controller: searchController,
                labelText: 'Search by name', 
                onChanged: (query) {
                  // Add the query to the stream
                  searchQueryController.add(query!);
                },
              ),

              // List of players
              StreamBuilder<String>(
                stream: searchQueryController.stream,
                initialData: '',
                builder: (context, snapshot) {
                  final query = snapshot.data ?? '';
                  updateFilteredPlayersForSearch(query);

                  return Expanded(
                    child: Builder(
                      builder: (innerContext) {
                        return ListView.builder(
                          itemCount: filteredPlayers.length,
                          itemBuilder: (context, index) {
                            final player = filteredPlayers[index];
                            final team = teams.firstWhere(
                              (team) => team['team_id'] == player['team_id'],
                              orElse: () => {'team_name': "None"},
                            );

                            return PlayerListTile(
                              playerName: '${player['fname']} ${player['lname']}',
                              teamName: team['team_name'],
                              playerImageURL: player['player_image_url'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewPlayer(
                                      playerMap: player,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
