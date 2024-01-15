import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/stats/top_assist_providers.dart';
import 'package:apl/stats/top_clean_sheets.dart';
import 'package:apl/stats/top_scorers.dart';
import 'package:flutter/material.dart';

import '../../helper_classes/custom_list_tile.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {



  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const APLAppBar(),
        body:  Center(
          child: ListView(
            
            children: [

              Container(
                margin: const EdgeInsets.only(top: 20),
              ),

              // goals, assists, clean sheets section
              MenuListTile(
                text: "Goals",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TopScorers()),
                  );
                },
              ),
              MenuListTile(
                text: "Assists",
                 onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TopAssistProviders()),
                  );
                },
              ),

              // space between sections
              Container(
                margin: const EdgeInsets.only(top: 10),
              ),

              MenuListTile(
                text: "Clean Sheets",
                onTap: () { Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TopCleanSheets()),
                  );
                },
              ),

              // space between sections

              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              // ),
              // MenuListTile(
              //   text: "Fouls",
              //   onTap: () {},
              // ),
              // MenuListTile(
              //   text: "Yellow Cards",
              //   onTap: () {},
              // ),
              // MenuListTile(
              //   text: "Red Cards",
              //   onTap: () {},
              // ),


            ],
          )
        ),
        backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
      )
      
    );
  }
}