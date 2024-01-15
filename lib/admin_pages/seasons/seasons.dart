import 'dart:convert';
import 'package:apl/admin_pages/seasons/add_season.dart';
import 'package:apl/admin_pages/seasons/edit_season.dart';
import 'package:apl/admin_pages/seasons/season_competitions.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../requests/seasons/delete_season_req.dart';
import '../../helper_classes/search_field.dart';



class Seasons extends StatefulWidget {
  const Seasons({super.key});

  @override
  _SeasonsState createState() => _SeasonsState();
}

class _SeasonsState extends State<Seasons> {

  List<Map<String, dynamic>> seasons = [];
  List<Map<String, dynamic>> filteredSeasons = [];

  List<Map<String, dynamic>> teams = [];

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the seasons
  void initState() {
    super.initState();

    // Call the function to get the seasons when the page loads
    getSeasons().then((result) {
      setState(() {
        seasons = result;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // if the list of seasons is empty, return "No players found"
    if (seasons.isEmpty) {
      return Column(

        children: [

          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSeason(
                    pageName: 'Add Season',
                  )
                ),
              );
            },
            text: "Add Season"
          ),

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

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          SearchField(
            onChanged: (value) {
            },
            labelText: 'Search by name',
          ),

          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSeason(
                    pageName: 'Add Season',
                  )
                ),
              );
            },
            text: "Add Season"
          ),

          // List of seasons
          Expanded(
            child: ListView.builder(
              itemCount: seasons.length,
              itemBuilder: (context, index) {
                final season = seasons[index];
             

                
                return AdminListTileWithOnTap(
                  title: '${season['season_name']}',
                  subtitle: '${season['start_date']} - ${season['end_date']}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeasonCompetitions(
                          pageName: 'Edit Season',
                          seasonDetails: season,
                        )
                      ),
                    );
                  },
                  editOnTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSeason(
                          pageName: 'Edit Season',
                          seasonDetails: season,
                        )
                      ),
                    );
                  },
                  deleteOnTap: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return DeleteConfirmationDialogBox(
                          title: "Delete Season", 
                          content: "Are you sure you want to delete this season?",
                          onPressed: () async {
                             Map <String, dynamic> response = await deleteSeason(
                              jsonEncode(
                                {
                                  'season_id': season['season_id'],
                                }
                              )
                            );

                            if (!mounted) return;

                            if (response['status'] == 'success') {
                              setState(() {
                                seasons.removeAt(index);
                              });

                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return ErrorDialogueBox(
                                    text: "Success", 
                                    content: response['message'],
                                  );
                                }
                              );
                            }

                            else {
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return ErrorDialogueBox(
                                    text: "Error", 
                                    content: response['message'],
                                  );
                                }
                              );
                            }
                            
                          },
                        );
                      }
                    );
                  },
                );
              },
            )
          ),
        ]
      )
    );
  }
}