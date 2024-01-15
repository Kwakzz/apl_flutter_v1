import 'dart:convert';

import 'package:apl/admin_pages/coaches/add_coach.dart';
import 'package:apl/admin_pages/coaches/edit_coach.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/error_handling.dart';
import 'package:apl/helper/widgets/text.dart';
import 'package:apl/helper/functions/convert_to_json.dart';
import 'package:apl/requests/coach/delete_coach.dart';
import 'package:apl/requests/coach/get_coaches_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../requests/teams/get_teams_req.dart';
import '../../helper_classes/search_field.dart';


class Coaches extends StatefulWidget {
  const Coaches({super.key});

  @override
  _CoachesState createState() => _CoachesState();
}

class _CoachesState extends State<Coaches> {

  List<Map<String, dynamic>> coaches = [];

  List<Map<String, dynamic>> teams = [];

  @override
  void initState() {
    super.initState();

    getCoaches().then((result) {
      setState(() {
        coaches = result;
        filteredCoaches = coaches;
      });
    });

    // Call the function to get the teams when the page loads
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

  }

  String searchQuery = '';

  // list of coaches for the search bar
  List<Map<String, dynamic>> filteredCoaches = [];

  /// This function is called when the search bar is used.
  void updateFilteredCoaches(String query) {
    filteredCoaches = coaches.where((player) {
      final fullName = '${player['fname']} ${player['lname']}'.toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();
  }


  @override
  Widget build(BuildContext context) {

    if (coaches.isEmpty) {
      return  Column(

        children: [
          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCoach(
                    pageName: 'Add Coach',
                  )
                ),
              );
            },
            text: "Add Coach"
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText(
                text: 'No coaches found',
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
              setState(() {
                searchQuery = value!;
                updateFilteredCoaches(searchQuery);
              });
            },
            labelText: 'Search by name',
          ),

          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCoach(
                    pageName: 'Add Coach',
                  )
                ),
              );
            },
            text: "Add Coach"
          ),

          // List of fans
          Expanded(
            child: ListView.builder(
              itemCount: filteredCoaches.length,
              itemBuilder: (context, index) {
                final coach = filteredCoaches[index];
                final team = teams.firstWhere(
                  (team) => team['team_id'] == coach['team_id'],
                  orElse: () => {'team_name': "None"},
                );

                
                return AdminListTile(
                  title: '${coach['fname']} ${coach['lname']}',
                  subtitle:'${team['team_name']}',
                  editOnTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => EditCoach(
                          pageName: "Edit Coach", 
                          coachDetailsMap: jsonDecode(
                            convertEditedCoachDetailsToJson(
                              coach['coach_id'],
                              coach['fname'], 
                              coach['lname'], 
                              coach['gender'], 
                              coach['date_of_birth'], 
                              team['team_name'], 
                              coach['year_group'], 
                              coach['is_retired']
                            )
                          ),
                        )
                      ),
                    );  
                  }, 
                  deleteOnTap: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return DeleteConfirmationDialogBox(
                          title: "Delete Coach", 
                          content: "Are you sure you want to delete this coach?", 
                          onPressed: () async {
                            Map<String, dynamic> response= await deleteCoach(
                              jsonEncode(
                                {
                                'coach_id': coach['coach_id'],
                                }
                              )
                            );

                            if (!mounted) return;

                            if (response['status']) {
                              setState(() {
                                // Refresh the page
                                coaches.removeAt(index);
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
                              
                              ErrorHandling.showError(
                                response['message'], 
                                context,
                                'Error'
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
      )
    );
  }
}