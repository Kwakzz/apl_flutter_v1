import 'package:apl/create_user.dart';
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/helper_classes/user_preferences.dart';
import 'package:apl/homepage.dart';
import 'package:apl/pl/club_details.dart';
import 'package:apl/requests/teams/get_teams_req.dart';
import 'package:apl/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper_classes/custom_list_tile.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {

  // A list of teams
  List <Map <String, dynamic>> teams = [];

  bool isLoggedIn = false;
  int? teamId = 0;
  Map<String, dynamic> favouriteTeam = {};

  /// this function logs the user out of the app
  void logOut() async {
    UserPreferences().removeUser();
    teamId = 0;
  }

  /// Checks if the user is logged in and if the user is an admin. If the user is as admin, set the isAdmin variable to true.
  Future<void> setLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = prefs.containsKey('email_address');
      teamId = prefs.getInt('team_id');
    });

    if (!isLoggedIn) {
      setState(() {
        teamId = 0;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    setLoggedInState();
    getTeams().then((result) {
      setState(() {
        teams = result;
        if (teamId!=0) {
          favouriteTeam = teams.firstWhere((element) => element['team_id'] == teamId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    List noSignInListViewChildren = <Widget> [

      Container(
        margin: const EdgeInsets.only(top: 10),
      ),

      // sign in, sign up section
      MenuListTile(
        text: "Sign in",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignIn(
                pageName: "Sign In",
              ),
            ),
          );
        },
      ),
              
      MenuListTile(
        text: "Sign up",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateUser(
                pageName: "Sign Up",
              ),
            ),
          );
        },
      ),

      // space between sections
      Container(
        margin: const EdgeInsets.only(top: 20),
      ),

      // privacy, FAQS section
      MenuListTile(
        text: "Privacy Policy",
        onTap: () {},
      ),
      MenuListTile(
        text: "FAQs",
        onTap: () {},
      ),

    ];


     List signInListViewChildren = [

      Container(
        margin: const EdgeInsets.only(top: 10),
      ),

      // sign in, sign up section
      MenuListTile(
        text: "Sign Out",
        textColor: Colors.white,
        tileColor: const Color.fromARGB(255, 71, 108, 255),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialogueBox(
                text: "Success",
                content: "You've signed out successfully!",
              );
            }
          );
          logOut();
          // refresh the page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
      ),

      // space between sections
      Container(
        margin: const EdgeInsets.only(top: 10),
      ),


      Container(
        margin: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
        child: const AppText(
          color: Colors.white,
          text: "Account Settings",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )
      ),

      MenuListTile(
        text: "Manage Account",
        onTap: () {},
      ),
      MenuListTile(
        text: "Change Email Address",
        onTap: () {},
      ),
      MenuListTile(
        text: "Change Password",
        onTap: () {},
      ),



      // space between sections
      Container(
        margin: const EdgeInsets.only(top: 10),
      ),

      Container(
        margin: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
        child: const AppText(
          color: Colors.white,
          text: "Favourite Team",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )
      ),

      // Favourite team List Tile
      FavTeamMenuListTile(
        teamName: favouriteTeam['team_name'] ?? "No Favourite Team",
        teamLogoURL: favouriteTeam['team_logo_url'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubDetails(
                team: favouriteTeam,
              ),
            ),
          );
        },
      ),

      // space between sections
      Container(
        margin: const EdgeInsets.only(top: 10),
      ),

      Container(
        margin: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
        child: const AppText(
          color: Colors.white,
          text: "Other",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )
      ),


      // privacy, FAQS section
      MenuListTile(
        text: "Privacy Policy",
        onTap: () {},
      ),
      MenuListTile(
        text: "FAQs",
        onTap: () {},
      ),
      
    ];


    return  MaterialApp(
      home: Scaffold(
        appBar: const APLAppBar(),
        body:  Center(
          child: ListView(
            // if the user is not logged in, show the noSignInListViewChildren list. If the user is logged in, show the signInListViewChildren list.
            children: [
              if (!isLoggedIn) ...noSignInListViewChildren,
              if (isLoggedIn) ...signInListViewChildren,
            ]
          )
        ),
        backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
      )
      
    );
  }
}