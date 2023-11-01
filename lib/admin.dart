import 'package:apl/admin_pages/admins/admins.dart';
import 'package:apl/admin_pages/coaches/coaches.dart';
import 'package:apl/admin_pages/gameweeks/gameweeks.dart';
import 'package:apl/admin_pages/news/news_items.dart';
import 'package:apl/admin_pages/seasons/seasons.dart';
import 'package:apl/admin_pages/standings/standings.dart';
import 'package:apl/admin_pages/teams/teams.dart';
import 'package:apl/admin_pages/users/users.dart';
import 'package:apl/admin_pages/players/players.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/homepage.dart';
import 'package:flutter/material.dart';


/// Class for Admin page
/// This screen is only accessible to the admin.
/// It allows the admin user to easily add, remove, update or read data from the database.
class Admin extends StatefulWidget {

  const Admin(
    {
      super.key,
      required this.pageName,
    }
  );

  // name of the page
  final String pageName;

  @override
  // ignore: library_private_types_in_public_api
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  String pageName = "Admin";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // selected tile
  String selectedTile = "Fans";

  

  @override
  Widget build(BuildContext context) {

    /// This function is called when the user taps on a tile in the drawer.
    /// It changes the selected tile and closes the drawer.
    /// Based on the selected tile, the body of the page is changed.
    Widget getContent() {
      switch (selectedTile) {

        // User-related tiles
        case 'Fans':
          return const Fans();
        case 'Admins':
          return const Admins();
        case 'Players':
          return const Players();
        case 'Coaches':
          return const Coaches();

        // Team-related tiles
        case 'Teams':
          return const Teams();

        // Season-related tiles
        case 'Seasons':
          return const Seasons();

        // Standings-related tiles
        case 'Standings':
          return const Standings(); 

        // Gameweek-related tiles
        case 'Gameweeks':
          return const Gameweeks();

        // News-related tiles
        case 'News':
          return const NewsItems();

        default:
          return const Text('No content available');
      }
    }

    return Scaffold(
      key: _scaffoldKey,

      // app bar
      appBar: AppBar(
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const AppText(
          text: 'Admin', 
          fontWeight: FontWeight.w600, 
          fontSize: 16, 
          color: Colors.white
        ),
        backgroundColor: const Color.fromARGB(255, 0, 53, 91),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            // Drawer Header
            const DrawerHeader(
              decoration: BoxDecoration(
                color:  Color.fromARGB(255, 0, 53, 91),
              ),
              child: AppText(
                text: 'Admin', 
                fontWeight: FontWeight.w600, 
                fontSize: 16, 
                color: Colors.white
              ),
            ),

            // Drawer Body
            // This is the list of tiles in the drawer
            // Each tile is a button
            // Each button navigates to a different screen

            // User-related tiles
            DrawerListTile(
              text: 'Fans',
              onTap: () {
                setState(() {
                  selectedTile = 'Fans';
                  Navigator.pop(context);
                });
              },
            ),

            DrawerListTile(
              text: 'Admins',
              onTap: () {
                setState(() {
                  selectedTile = 'Admins';
                  Navigator.pop(context);
                });
              },
            ),

            DrawerListTile(
              text: 'Players',
              onTap: () {
                setState(() {
                  selectedTile = 'Players';
                  Navigator.pop(context);
                });
              },
            ),

            DrawerListTile(
              text: 'Coaches',
              onTap: () {
                setState(() {
                  selectedTile = 'Coaches';
                  Navigator.pop(context);
                });
              },
            ),

            // space between user-related tiles and team tile
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),

            // Team-related tiles
            DrawerListTile(
              text: 'Teams',
              onTap: () {
                setState(() {
                  selectedTile = 'Teams';
                  Navigator.pop(context);
                });
              },
            ),

            // space between team-related tiles and season-related tiles
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),

            // Season-related tiles
            DrawerListTile(
              text: 'Seasons',
              onTap: () {
                setState(() {
                  selectedTile = 'Seasons';
                  Navigator.pop(context);
                });
              },
            ),

            DrawerListTile(
              text: 'Competitions',
              onTap: () {
                setState(() {
                  selectedTile = 'Competitions';
                  Navigator.pop(context);
                });
              },
            ),

            DrawerListTile(
              text: 'Standings',
              onTap: () {
                setState(() {
                  selectedTile = 'Standings';
                  Navigator.pop(context);
                });
              },
            ),

            // space between season-related tiles and game-related tiles
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),

            // Game-related tiles
            DrawerListTile(
              text: 'Gameweeks',
              onTap: () {
                setState(() {
                  selectedTile = 'Gameweeks';
                  Navigator.pop(context);
                });
              },
            ),

            // space between gameweeks and news tiles
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),

            // News-related tiles
            DrawerListTile(
              text: 'News',
              onTap: () {
                setState(() {
                  selectedTile = 'News';
                  Navigator.pop(context);
                });
              },
            ),

            // space between news and exit tiles
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),

            // Exit tile
            DrawerListTile(
              text: "Return to app",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(
                      
                    ),
                  ),
                );
              },
            ),

          ]
        )
      ),

     

      // body
      // body is a list view. It contains a list of tiles. Each tile is a button.
      // there'll be section of tiles. For example, one section for everything related to users, one section for everything related to games, etc.
      body: getContent()
    );
  }

}