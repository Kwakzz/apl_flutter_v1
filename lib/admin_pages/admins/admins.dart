import 'dart:convert';
import 'package:apl/admin_pages/users/add_user.dart';
import 'package:apl/admin_pages/users/edit_user.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/admin/delete_user_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_list_tile.dart';
import '../../requests/admin/get_admins_req.dart';
import '../../requests/teams/get_teams_req.dart';
import '../../helper_classes/search_field.dart';

class Admins extends StatefulWidget {
  const Admins({super.key});

  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {

  // list of fans
  List<Map<String, dynamic>> admins = [];

  // list of teams
  List<Map<String, dynamic>> teams = [];

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the fans.
  void initState() {

    super.initState();
    
    // Call the function to get the fans when the page loads
    getAdmins().then((result) {
      setState(() {
        admins = result;
      });
    });

    // Call the function to get the teams when the page loads
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });

  }


  @override
  Widget build(BuildContext context) {

    if (admins.isEmpty) {
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
                  text: 'No admins found',
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
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final admin = admins[index];
              final team = teams.firstWhere(
                (team) => team['team_id'] == admin['team_id'],
                orElse: () => {'team_name': 'None'},
              );
              return AdminListTile(
                title: '${admin['fname']} ${admin['lname']}',
                subtitle: '${admin['email_address']}',
                editOnTap: () {
                // Add team name to fan map
                  admin['team_name'] = team['team_name'];
                  // Move to edit fan page
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => EditUser(
                        pageName: 'Edit User',
                        personalDetailsMap: admin,
                      )
                    ),
                  ); 
                },
                deleteOnTap: () {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return DeleteConfirmationDialogBox(
                        title: "Delete Admin", 
                        content: "Are you sure you want to delete this admin?", 
                        onPressed: () async {

                            Map <String, dynamic> response = await deleteUser(jsonEncode(admin));

                            if (!mounted) return;

                            if (response['status']) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:const Color.fromARGB(255, 28, 28, 28),
                                  content: AppText(
                                    text: response['message'],
                                    fontWeight: FontWeight.w300, 
                                    fontSize: 12, 
                                    color: Colors.white
                                  ),
                                  duration:const Duration(seconds: 2),
                                )
                              );

                              // refresh the page
                              setState(() {
                                admins.removeAt(index);
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