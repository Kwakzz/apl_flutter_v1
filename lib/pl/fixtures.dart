import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/pl/mens_fixtures_view.dart';
import 'package:apl/requests/teams/get_teams_req.dart';
import 'package:apl/pl/womens_fixtures_view.dart';
import 'package:flutter/material.dart';



class Fixtures extends StatefulWidget {
  const Fixtures(
    {
      super.key,
      required this.pageName,
    }
  );

  final String pageName;

  @override
  _FixturesState createState() => _FixturesState();
}

class _FixturesState extends State<Fixtures> {

  List<Map<String, dynamic>> seasonsMap = [];

  List<Map<String, dynamic>> gameweeks = [];

  List<Map<String, dynamic>> teams = [];

  // map of selected season
  Map <String, dynamic> selectedSeasonMap = {};


  @override
  /// This function is called when the page loads.
  /// It calls the function to get the fans, teams and positions.
  /// It also sets the filteredCoaches list to the coaches list.
  void initState() {
    super.initState();

    // get teams when the page loads
    // they are needed to display the team name instead of the team id so that we can
    // have something like "Elite vs Kasanoma" instead of "1 vs 2"
    getTeams().then((result) {
      setState(() {
        teams = result;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    // The tabs for the tab bar
    final List<Tab> myTabs = <Tab>[
      const Tab(text: 'Men'),
      const Tab(text: 'Women'),
    ];

    return Scaffold(
       body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppbarWithTabs(
            height: 100,
            pageName: widget.pageName,
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: const TabBarView(
            children: [
              MensFixturesView(),
              WomensFixturesView(),
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
    );
  }
}