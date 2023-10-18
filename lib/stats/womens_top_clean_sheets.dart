import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/helper_classes/my_data_table.dart';
import 'package:apl/requests/goal/get_season_comp_clean_sheets_req.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:flutter/material.dart';

import '../requests/competitions/get_womens_comps_req.dart';


class WomensTopCleanSheets extends StatefulWidget {
  const WomensTopCleanSheets(
    {
      super.key,

    }
  );


  @override
  _WomensTopCleanSheetsState createState() => _WomensTopCleanSheetsState();
}

class _WomensTopCleanSheetsState extends State<WomensTopCleanSheets> {

  List<Map<String, dynamic>> seasonsMap = [];

  List<Map<String, dynamic>> compsMap = [];

  List<Map<String, dynamic>> topCleanSheets = [];

  // map of selected season
  Map <String, dynamic> selectedSeasonMap = {};

  // map of the selected competition for the selected season
  Map <String, dynamic> selectedCompMap = {};
  

  @override
  /// This function is called when the page loads.
  /// It loads the seasons, competitions, fixtures and teams.
  void initState() {
    super.initState();

    // Call the function to get the seasons when the page loads
    getSeasons().then((result) {
      setState(() {
        seasonsMap = result;
        if (seasonsMap.isNotEmpty) {
          // set selected season map to the first season map
          // This is the most recent season
          selectedSeasonMap = seasonsMap.first;
        } else {
          selectedSeasonMap = {};
        }
      }
    );
    });

    // load all women's competitions
    getWomensCompetitions().then((result) {
      setState(() {
        compsMap = result;
      });

      // set selected comp map to the first comp map
      if (compsMap.isNotEmpty) {
        selectedCompMap = compsMap.first;
      } else {
        selectedCompMap = {};
      }

      // load the teams with the most clean sheets in the selected season and competition
      try{
        getSeasonCompTopCleanSheets(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
          setState(() {
            topCleanSheets = result;
          });
        });
      }

      catch(e){
        return e;
      }

          
    });

  }


  @override
  Widget build(BuildContext context) {

    // list of season names
    // will be used to display the season names in the dropdown menu
    final seasonNames = seasonsMap.map((season) => season['season_name'] as String).toList();

    // list of competition names
    // will be used to display the competition names in the dropdown menu
    final compNames = compsMap.map((comp) => comp['competition_name'] as String).toList();


    // season drop down menu
    MyDropdownFormField seasonsDropDown = MyDropdownFormField(
      items: seasonNames,
      selectedValue: selectedSeasonMap["season_name"],
      labelText: "Season",
      onChanged: (newValue) {
        setState(() {
          // set selected season map to the season map of the selected season
          // or else return an empty map if the season is not found
          selectedSeasonMap = seasonsMap.firstWhere(
            (season) => season["season_name"].toString() == newValue,
            orElse: () => {},
          );

          getSeasonCompTopCleanSheets(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
            setState(() {
              topCleanSheets = result;
            });

          });
        }
        );
      }
    );

    // competition drop down menu
    MyDropdownFormField compsDropDown = MyDropdownFormField(
      items: compNames,
      selectedValue: selectedCompMap["competition_name"],
      labelText: "Competition",
      onChanged: (newValue) {
        setState(() {
          // set selected comp map to the comp map of the selected comp
          // or else return an empty map if the comp is not found
          selectedCompMap = compsMap.firstWhere(
            (comp) => comp["competition_name"].toString() == newValue,
            orElse: () => {},
          );

           // load the teams with the most clean sheets in the selected season and competition
          getSeasonCompTopCleanSheets(selectedSeasonMap['season_id'], selectedCompMap['competition_id']).then((result) {
            setState(() {
              topCleanSheets = result;
            });
          });
        }
        );
      }
    );


    return Column(
        children: [
          seasonsDropDown,
          compsDropDown,

          TopCleanSheetsTable(topCleanSheets: topCleanSheets)
          
        ],
    );

  }
}