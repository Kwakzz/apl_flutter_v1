import 'dart:convert';

import 'package:apl/create_user.dart';
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/helper_classes/user_preferences.dart';
import 'package:apl/homepage.dart';
import 'package:apl/pl/club_details.dart';
import 'package:apl/privacy_policy.dart';
import 'package:apl/requests/teams/get_teams_req.dart';
import 'package:apl/requests/user/reset_password_req.dart';
import 'package:apl/sign_in.dart';
import 'package:apl/social_media_page.dart';
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
  String? emailAdress = "";
  Map<String, dynamic> favouriteTeam = {};
  String fname = "";

  /// this function logs the user out of the app
  void logOut() async {
    Map<String, dynamic> logOutResponse = await UserPreferences().removeUser();

    if (!mounted) return;

    if (logOutResponse['isRemoved']) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialogueBox(
            text: 'Sign Out',
            content: logOutResponse['message'],
          );
        }
      );
    } 
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialogueBox(
            text: 'Sign Out Error',
            content: logOutResponse['message'],
          );
        }
      );
    }
  }

  /// Checks if the user is logged in. It checks this by checking if the user's email address is in the shared preferences. If the user is logged in, it retrieves the user's favourite team, email address and first name from the shared preferences. 
  Future<void> setLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = prefs.containsKey('email_address');

      if (isLoggedIn) {
        teamId = prefs.getInt('team_id');
        emailAdress = prefs.getString('email_address');
        fname = prefs.getString('fname') ?? "";
        getTeams().then((result) {
        setState(() {
          teams = result;
          if (teamId!=0) {
            favouriteTeam = teams.firstWhere((element) => element['team_id'] == teamId);
          }
        });
      });
      }
    });

  }

  @override
  void initState() {
    super.initState();
    try {
      setLoggedInState();
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {

    List noSignInListViewChildren = <Widget> [

      Container(
        margin: const EdgeInsets.only(top: 10),
      ),

      Container(
        margin: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
        child: const AppText(
          color: Colors.white,
          text: "Account Actions",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )
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
        margin: const EdgeInsets.only(top: 10),
      ),

      // social media  
      Container(
        margin: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
        child: const AppText(
          color: Colors.white,
          text: "Social Media",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )
      ),

      SocialMediaLinkMenuListTile(
        platformName: "Twitter", 
        platformLogo: 'https://res.cloudinary.com/dvghxq3ba/image/upload/v1697199503/Social%20Media%20Logos/logo-black_knly8o.png',
        onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SocialMediaPage(
                  url: 'https://twitter.com/AshesiFootball',
                ),
              ),
            );
        }
      ),

      SocialMediaLinkMenuListTile(
        platformName: "Instagram", 
        platformLogo: 'https://res.cloudinary.com/dvghxq3ba/image/upload/v1697337068/Social%20Media%20Logos/Instagram_Glyph_Black_drwokr.png',
        onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SocialMediaPage(
                  url: 'https://www.instagram.com/ashesi_football/',
                ),
              ),
            );
        }
      ),

      // space between sections
      Container(
        margin: const EdgeInsets.only(top: 10),
      ),

      // Other section
      Container(
        margin: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
        child: const AppText(
          color: Colors.white,
          text: "Other",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )
      ),

      // privacy 
      MenuListTile(
        text: "Privacy Policy",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrivacyPolicyPage()
            ),
          );
        },
      ),

      // FAQS section
      // MenuListTile(
      //   text: "FAQs",
      //   onTap: () {
          
      //   },
      // ),

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
          // ask for confirmation
          showDialog(
            context: context, 
            builder: (BuildContext context) {
              return ActionConfirmationDialogBox(
                title: 'Sign Out',
                content: 'Are you sure you want to sign out?',

                // if the user confirms that they want to sign out, log them out
                onPressed: () {
                  logOut();
                  // refresh the page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
              );
            }
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

      // MenuListTile(
      //   text: "Manage Account",
      //   onTap: () {},
      // ),

      // MenuListTile(
      //   text: "Change Email Address",
      //   onTap: () {},
      // ),
      MenuListTile(
        text: "Change Password",
        onTap: () {
          String emailJson =  jsonEncode(
            <String, dynamic> {
              'email_address': emailAdress
            }
          );

          // Ask the user to confirm if they want to reset their password
          showDialog(
            context: context, 
            builder: (BuildContext context) {
              return ActionConfirmationDialogBox(
                title: 'Password Reset',
                content: 'Are you sure you want to reset your password?',

                // if the user confirms that they want to reset their password, send a request to the server to reset their password
                onPressed: () async {
                   Map<String, dynamic> response = await resetPassword(emailJson);

                  if (!mounted) return;
                  

                  if (response['status']) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialogueBox(
                          text: 'Password Reset',
                          content: response['message'],
                        );
                      }
                    );
                  } 
                  else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialogueBox(
                          text: 'Password Reset Error',
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

          if (teamId != 0 && favouriteTeam.isNotEmpty) {  
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClubDetails(
                  team: favouriteTeam,
                ),
              ),
            );
          }

        },
      ),

      // space between sections
      Container(
        margin: const EdgeInsets.only(top: 10),
      ),

      // social media  
      Container(
        margin: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
        child: const AppText(
          color: Colors.white,
          text: "Social Media",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )
      ),

      SocialMediaLinkMenuListTile(
        platformName: "Twitter", 
        platformLogo: 'https://res.cloudinary.com/dvghxq3ba/image/upload/v1697199503/Social%20Media%20Logos/logo-black_knly8o.png',
        onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SocialMediaPage(
                  url: 'https://twitter.com/AshesiFootball',
                ),
              ),
            );
        }
      ),

      SocialMediaLinkMenuListTile(
        platformName: "Instagram", 
        platformLogo: 'https://res.cloudinary.com/dvghxq3ba/image/upload/v1697337068/Social%20Media%20Logos/Instagram_Glyph_Black_drwokr.png',
        onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SocialMediaPage(
                  url: 'https://www.instagram.com/ashesi_football/',
                ),
              ),
            );
        }
      ),

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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrivacyPolicyPage()
            ),
          );
        },
      ),
      // MenuListTile(
      //   text: "FAQs",
      //   onTap: () {},
      // ),

      
      
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