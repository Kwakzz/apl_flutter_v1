import 'dart:convert';
import 'package:apl/admin_pages/games/add_cup_game.dart';
import 'package:apl/admin_pages/games/add_league_game.dart';
import 'package:apl/admin_pages/games/edit_game.dart';
import 'package:apl/admin_pages/games/game_details.dart';
import 'package:apl/helper_classes/app_bar_bottom_row.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/games/delete_game_req.dart';
import 'package:flutter/material.dart';

import '../../helper_classes/custom_dialog_box.dart';



class GamesView extends StatefulWidget {
  const GamesView(
    {
      super.key,
      required this.gameweekMap,
      required this.games,
      required this.teams
    }
  );

  final Map<String, dynamic> gameweekMap;
  final List<Map<String, dynamic>> games;
  final List<Map<String, dynamic>> teams;

  @override
  _GamesViewState createState() => _GamesViewState();
}

class _GamesViewState extends State<GamesView> {



  @override
  Widget build(BuildContext context) {

    // if the list of games is empty, return "No games found"
    if (widget.games.isEmpty) {

      return Column(
        children: [

          AppBarBottomRow(
            children: [
              // add league game button
              AddButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddLeagueGame(
                        pageName:  "Add League Game to Gameweek ${widget.gameweekMap['gameweek_number']}",
                        gameweekDetails: widget.gameweekMap,
                      )
                    ),
                  );
                },
                text: "Add League Game"
              ),

              // add cup game button
              AddButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCupGame(
                        pageName:  "Add Cup Game to Gameweek ${widget.gameweekMap['gameweek_number']}",
                        gameweekDetails: widget.gameweekMap,
                      )
                    ),
                  );
                },
                text: "Add Cup Game"
              ),
            ],
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText(
                text: 'No games found',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )
            )
          ),   
        ]
      );
    }
    
    return Column(
      children: [

        AppBarBottomRow(
          children: [
            // add league game button
            AddButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLeagueGame(
                      pageName:  "Add League Game to Gameweek ${widget.gameweekMap['gameweek_number']}",
                      gameweekDetails: widget.gameweekMap,
                    )
                  ),
                );
              },
              text: "Add League Game"
            ),

            // add cup game button
            AddButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCupGame(
                      pageName:  "Add Cup Game to Gameweek ${widget.gameweekMap['gameweek_number']}",
                      gameweekDetails: widget.gameweekMap,
                    )
                  ),
                );
              },
              text: "Add Cup Game"
            ),
          ]
        ),

        // List of games
        Expanded(
          child: ListView.builder(
            itemCount: widget.games.length,
            itemBuilder: (context, index) {

              final game = widget.games[index];

              Map <String, dynamic> homeTeamFinal = {};
              Map <String, dynamic> awayTeamFinal = {};

              try {
                // get the team names from the team id in the game map
                final homeTeam = widget.teams.firstWhere((team) => team['team_id'] == game['home_id']);
                homeTeamFinal = homeTeam;

                final awayTeam = widget.teams.firstWhere((team) => team['team_id'] == game['away_id']);
                awayTeamFinal = awayTeam;

              } catch (e) {
                // circular progress indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

                
              return AdminListTileWithOnTap(
                title: '${homeTeamFinal['team_name']} vs ${awayTeamFinal['team_name']}',
                subtitle: '${game['competition_name']}',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetails(
                        pageName: '${homeTeamFinal['team_name_abbrev']} vs ${awayTeamFinal['team_name_abbrev']}',
                        gameDetails: game,
                        gameweekDetails: widget.gameweekMap,
                        homeTeam: homeTeamFinal,
                        awayTeam: awayTeamFinal,
                      )
                    ),
                  );
                },
                editOnTap: ()  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditGame(
                        pageName: 'Edit Game',
                        gameDetails: game,
                        gameweekDetails: widget.gameweekMap,
                      )
                    ),
                  );
                },
                deleteOnTap: () {
                  showDialog(
                    context: context, 
                    builder: (context)  {
                      return DeleteConfirmationDialogBox(
                        title: "Delete Game", 
                        content: "Are you sure you want to delete this game?", 
                        onPressed: () async {

                          Map <String, dynamic> response = await deleteGame(jsonEncode(game));

                          if (!mounted) return;

                          if (response['status']) {
                            showDialog(
                              context: context, 
                              builder: (context) {
                                return ErrorDialogueBox(
                                  content: response['message'], 
                                  text: "Success",
                                );
                              }
                            );
                            // refresh the page
                            setState(() {
                              widget.games.removeAt(index);
                            });
                          } 
                          
                          else {
                            showDialog(
                              context: context, 
                              builder: (context) {
                                return ErrorDialogueBox(
                                  content: response['message'], 
                                );
                              }
                            );
                          }
                        }
                      );
                    }
                  );
                  
                },
              );
            },
          )
        ),
      ]
    );
  }
}