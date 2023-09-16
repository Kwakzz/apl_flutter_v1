
import 'package:apl/admin_pages/standings/add_standings_form.dart';
import 'package:apl/requests/competitions/get_mens_comps_req.dart';
import 'package:apl/requests/competitions/get_womens_comps_req.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_appbar.dart';

class AddStandings extends StatefulWidget {
  const AddStandings(
    {
      super.key,
      required this.pageName,
    }
  );

  // The name of the page
  final String pageName;


  @override
  _AddStandingsState createState() => _AddStandingsState();
}

class _AddStandingsState extends State<AddStandings> {


  List<Map<String, dynamic>> mensComps = [];
  List<Map<String, dynamic>> womensComps = [];
  List<Map<String, dynamic>> seasons = [];



  @override
  /// This function is called when the page loads.
  void initState() {
    super.initState();

    getSeasons().then((result) {
      setState(() {
        seasons = result;
      });
    });

    // Call the function to get all men's competitions
    getMensCompetitions().then((result) {
      setState(() {
        mensComps = result;
      });
    });

    // Call the function to get all women's competitions 
    getWomensCompetitions().then((result) {
      setState(() {
        womensComps = result;
      });
    });


  }

  @override
  Widget build(BuildContext context) {

    List <Widget> myTabs = const [
      Tab(
        text: "Men's"
      ),
      Tab(
        text: "Women's"
      ),
    ];


    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppbarWithTabs(
            pageName: "Add Table",
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: TabBarView(
            children: [
              AddStandingsForm(
                compsMap: mensComps, 
                seasonsMap: seasons
              ),

              AddStandingsForm(
                compsMap: womensComps, 
                seasonsMap: seasons
              )
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
    );





  }
}