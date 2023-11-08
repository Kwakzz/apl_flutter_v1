import 'dart:convert';
import 'package:apl/admin_pages/users/add_user.dart';
import 'package:apl/admin_pages/users/edit_user.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/admin/delete_user_req.dart';
import 'package:apl/requests/admin/get_regular_users_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_list_tile.dart';
import '../../requests/teams/get_teams_req.dart';
import '../../helper_classes/search_field.dart';

class Fans extends StatefulWidget {
  const Fans({super.key});

  @override
  _FansState createState() => _FansState();
}

class _FansState extends State<Fans> {

  // list of fans
  List<Map<String, dynamic>> fans = [];
  // list of teams
  List<Map<String, dynamic>> teams = [];

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the fans.
  void initState() {

    super.initState();
    
    // Call the function to get the regular users when the page loads.
    // Regular users are 
    getRegularUsers().then((result) {
      setState(() {
        fans = result;
        filteredFans = fans;
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
  
  // list of fans for the search bar
  List<Map<String, dynamic>> filteredFans = [];

  /// This function is called when the search bar is used.
  void updateFilteredFans(String query) {
    filteredFans = fans.where((user) {
      final fullName = '${user['fname']} ${user['lname']}'.toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();
  }

  
  

  @override
  Widget build(BuildContext context) {

    // if the fans list is empty
    if (fans.isEmpty) {
      return  Column(

          children: [
            SmallAddButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFan(
                      pageName: "Add User",
                    ),
                  ),
                );
              },
              text: "Add User"
            ),

            Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText(
                text: 'No users found',
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
              updateFilteredFans(searchQuery);
            });
          },
          labelText: 'Search by name',
        ),

        // Add fan button
        SmallAddButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFan(
                  pageName: "Add User",
                ),
              ),
            );
          },
          text: "Add User"
        ),

        // List of fans
        Expanded(
          child: ListView.builder(
            itemCount: filteredFans.length,
            itemBuilder: (context, index) {
              final fan = filteredFans[index];
              final team = teams.firstWhere(
                (team) => team['team_id'] == fan['team_id'],
                orElse: () => {'team_name': 'None'},
              );
              return AdminListTile(
                title: '${fan['fname']} ${fan['lname']}',
                subtitle: '${fan['email_address']}',
                editOnTap: () {
                // Add team name to fan map
                  fan['team_name'] = team['team_name'];
                  // Move to edit fan page
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => EditFan(
                        pageName: 'Edit User',
                        personalDetailsMap: fan,
                      )
                    ),
                  ); 
                },
                deleteOnTap: () {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return DeleteConfirmationDialogBox(
                        title: "Delete User", 
                        content: "Are you sure you want to delete this fan?", 
                         onPressed: () async {

                            Map <String, dynamic> response = await deleteUser(jsonEncode(fan));

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
                                fans.removeAt(index);
                              });
                              
                            } else {
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