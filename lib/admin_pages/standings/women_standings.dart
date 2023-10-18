import 'dart:convert';

import 'package:apl/admin_pages/standings/add_standings.dart';
import 'package:apl/admin_pages/standings/standings_teams.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:apl/requests/standings/get_season_comp_standings_without_teams_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../requests/competitions/get_womens_comps_req.dart';
import '../../requests/standings/delete_standings_req.dart';



class WomensStandings extends StatefulWidget {
  const WomensStandings({super.key});

  @override
  _WomensStandingsState createState() => _WomensStandingsState();
}

class _WomensStandingsState extends State<WomensStandings> {

  List<Map<String, dynamic>> seasonsMap = [];
  List<Map<String, dynamic>> compsMap = [];


  List<Map<String, dynamic>>  standings = [];

  // map of selected season
  Map <String, dynamic> selectedSeasonMap = {};
  // map of selected competition
  Map <String, dynamic> selectedCompMap = {};

  @override
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

          // get the standings for the selected season
          getSeasonCompStandingsWithoutTeams (
            selectedSeasonMap["season_id"],
            selectedCompMap["competition_id"]
          ).then((result) {
            setState(() {
              standings = result;
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

          // get the standings for the selected season
          getSeasonCompStandingsWithoutTeams (
            selectedSeasonMap["season_id"],
            selectedCompMap["competition_id"]
          ).then((result) {
            setState(() {
              standings = result;
            });
          });
        });
      }
    );

    // if the list of seasons is empty, return "No seasons found"
    if (seasonsMap.isEmpty) {
      return Column(

        children: const [
          
          Center(
            child: AppText(
            text: 'No seasons found',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            )
          ),
        ],
      );
    }

    // if the list of standings is empty, return "No standings found"
    if (standings.isEmpty) {
      return Column(
        children: [

          // Drop down menu for seasons
          seasonsDropDown,

          // Drop down menu for competitions
          compsDropDown,

          AddFanButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStandings(
                  pageName: "Add Table",
                )),
              );
            },
            text: "Add Standings"
          ),

          const Center(
            child: AppText(
            text: 'No standings found',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.black,
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

          // Drop down menu for competitions
          compsDropDown,

          AddFanButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStandings(
                  pageName: "Add Table",
                )),
              );
            },
            text: "Add Table"
          ),
          // List of gameweeks
          Expanded(
            child: ListView.builder(
              itemCount: standings.length,
              itemBuilder: (context, index) {
                final standing = standings[index];
                
                return AdminListTileWithOnTap(
                  title: standing['competition_name'],
                  subtitle: standing['season_name'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StandingsTeams(
                        standingsInfo: standing,
                      )),
                    );
                  },
                  editOnTap: () {
                    
                  },
                  deleteOnTap: () {
                    showDialog(
                        context: context, 
                        builder: (context) {
                          return DeleteConfirmationDialogBox(
                            title: "Delete Table", 
                            content: "Are you sure you want to delete this table?", 
                            onPressed: () async {
                              Map<String, dynamic> response = await deleteStandings(
                                jsonEncode(
                                  {
                                    'standings_id': standing['standings_id'],
                                  }
                                )
                              );

                              if (!mounted) return;

                              if (response['status']) {
                                // refresh the list of standings
                                setState(() {
                                  standings.removeAt(index);
                                });
                            

                                // show success dialog box
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
                                Navigator.pop(context);
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