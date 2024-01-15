import 'dart:convert';
import 'package:apl/admin_pages/games/games.dart';
import 'package:apl/admin_pages/gameweeks/add_gameweek.dart';
import 'package:apl/admin_pages/gameweeks/edit_gameweek.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:apl/requests/gameweeks/delete_gw_req.dart';
import 'package:apl/requests/gameweeks/get_season_gw_req.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:flutter/material.dart';



class Gameweeks extends StatefulWidget {
  const Gameweeks({super.key});

  @override
  _GameweeksState createState() => _GameweeksState();
}

class _GameweeksState extends State<Gameweeks> {

  List<Map<String, dynamic>> seasonsMap = [];

  List<Map<String, dynamic>> gameweeks = [];

  // map of selected season
  Map <String, dynamic> selectedSeasonMap = {};

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the fans, teams and positions.
  /// It also sets the filteredCoaches list to the coaches list.
  void initState() {
    super.initState();

    // Call the function to get the seasons when the page loads
    getSeasons().then((result) {
      setState(() {
        seasonsMap = result;
        if (seasonsMap.isNotEmpty) {
          selectedSeasonMap = seasonsMap.first;
        } else {
          selectedSeasonMap = {};
        }

        // Call the function to get the gameweeks of the selected season when the page loads
        // When the page loads, the selected season is the most recent season
        // The seasons are in a dropdown menu, so the user can select a season
        getSeasonGameweeks(selectedSeasonMap["season_id"]).then((result) {
          setState(() {
          gameweeks = result;
          });
        });
      }
    );
    });
  }


  @override
  Widget build(BuildContext context) {

    // list of season names
    // will be used to display the season names in the dropdown menu
    final seasonNames = seasonsMap.map((season) => season['season_name'] as String).toList();


    // season drop down menu
    // dropdown list for teams
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
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
          // load the gameweeks of the selected season
          getSeasonGameweeks(selectedSeasonMap["season_id"]).then((result) {
            setState(() {
              gameweeks = result;
            });
          });
        }
        );
      }
    );

    // if the list of seasons is empty, return "No seasons found"
    if (seasonsMap.isEmpty) {
      return Column(

        children: [

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText(
                text: 'No seasons found',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )
            )
          ),
        ],
      );
    }

    // if the list of gameweeks is empty, return "No gameweeks found"
    if (gameweeks.isEmpty) {
      return Column(
        children: [

          // Drop down menu for seasons
          seasonsDropDown,

          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddGameweek()),
              );
            },
            text: "Add Gameweek"
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText(
                text: 'No gameweeks found',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )
            )
          ),
        ],
      );
    }

    return Scaffold(
      body: Column(
        children: [

          // Drop down menu for seasons
          seasonsDropDown,

          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddGameweek()),
              );
            },
            text: "Add Gameweek"
          ),
          // List of gameweeks
          Expanded(
            child: ListView.builder(
              itemCount: gameweeks.length,
              itemBuilder: (context, index) {
                final gameweek = gameweeks[index];
                
                return AdminListTileWithOnTap(
                  title: 'Gameweek ${gameweek['gameweek_number']}',
                  subtitle: '${gameweek['gameweek_date']}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Games(
                          gameweekMap: gameweek,
                        )
                      ),
                    );
                  },
                  editOnTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditGameweek(
                          gameweekDetails: gameweek
                        )
                      ),
                    );
                  },
                  deleteOnTap: () async {
                    Map<String, dynamic> response = await deleteGameweek(
                      jsonEncode(
                        {
                          'gameweek_id': gameweek['gameweek_id'],
                        }
                      )
                    );

                    if (!mounted) return;

                    if (response['status']) {

                      // remove the gameweek from the list of gameweeks to update the UI
                      setState(() {
                        gameweeks.removeAt(index);
                      });

                      showDialog(
                        context: context, 
                        builder: (context) {
                          return ErrorDialogueBox(
                            content: response['message'],
                            text: "Success",
                          );

                        }
                      );
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
              },
            )
          ),
        ]
      ),
      // backgroundColor: const Color.fromARGB(255, 0, 53, 91),
    );
  }
}