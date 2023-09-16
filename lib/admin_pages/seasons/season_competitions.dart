
import 'package:apl/admin_pages/seasons/season_comps_view.dart';
import 'package:apl/requests/seasons/get_mens_season_comps_req.dart';
import 'package:apl/requests/seasons/get_womens_comps_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_appbar.dart';

class SeasonCompetitions extends StatefulWidget {
  const SeasonCompetitions(
    {
      super.key,
      required this.pageName,
      required this.seasonDetails,
    }
  );

  // The name of the page
  final String pageName;

  // The map of the season
  final Map<String, dynamic> seasonDetails;

  @override
  _SeasonCompetitionsState createState() => _SeasonCompetitionsState();
}

class _SeasonCompetitionsState extends State<SeasonCompetitions> {


  List<Map<String, dynamic>> mensComps = [];
  List<Map<String, dynamic>> womensComps = [];



  @override
  /// This function is called when the page loads.
  /// It calls the function to get the teams.
  /// It also sets the filteredTeams list to the teams list.
  void initState() {
    super.initState();

    // Call the function to get the men's competitions for the season when the page loads
    getMensSeasonComps(widget.seasonDetails['season_id']).then((result) {
      setState(() {
        mensComps = result;
      });
    });

    // Call the function to get the men's competitions for the season when the page loads
    getWomensSeasonComps(widget.seasonDetails['season_id']).then((result) {
      setState(() {
        womensComps = result;
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    List <Widget> myTabs = const [
      Tab(
        text: "Men"
      ),
      Tab(
        text: "Women"
      ),
    ];


    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppbarWithTabs(
            pageName: "Season Competitions",
            icon: const Icon(
              Icons.arrow_back,
            ),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: TabBarView(
            children: [
              // Men's view
              SeasonCompsView(
                comps: mensComps,
                seasonId: widget.seasonDetails['season_id'],
              ),
              // Women's view
              SeasonCompsView(
                comps: womensComps,
                seasonId: widget.seasonDetails['season_id'],
              )
            ]
          ),
        ),
      ),
    );





  }
}