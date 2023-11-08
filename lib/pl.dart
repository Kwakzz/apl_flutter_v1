import 'package:apl/pl/fixtures.dart';
import 'package:apl/pl/clubs.dart';
import 'package:apl/pl/coaches.dart';
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/pl/news.dart';
import 'package:apl/pl/players.dart';
import 'package:apl/pl/results.dart';
import 'package:apl/pl/tables.dart';
import 'package:flutter/material.dart';


class PL extends StatefulWidget {
  const PL({super.key});

  @override
  _PLState createState() => _PLState();

  

}

class _PLState extends State<PL> {



  @override
  Widget build(BuildContext context) {
    
    return  MaterialApp(
      home: Scaffold(
        appBar: const APLAppBar(),
        body:  Center(
          child: ListView(
            
            children: [ 

              // space between sections
              Container(
                margin: const EdgeInsets.only(top: 20),
              ),

              // fixtures, results, tables section
              MenuListTile(
                text: "Fixtures",
                onTap: () {
                  Navigator.push (
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Fixtures(
                        pageName: "Fixtures",
                      ),
                    ),
                  );
                },
              ),

              MenuListTile(
                text: "Results",
                onTap: () {
                  Navigator.push (
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Results(
                        pageName: "Results",
                      ),
                    ),
                  );
                },
              ),

              MenuListTile(
                text: "Tables",
                onTap: () {
                  Navigator.push (
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Tables(
                        pageName: "Tables",
                      ),
                    ),
                  );
                },
              ),

              // space between sections
              Container(
                margin: const EdgeInsets.only(top: 10),

              ),

              // players section
              MenuListTile(
                text: "Players",
                onTap: () {
                  Navigator.push (
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Players(
                        pageName: "Players",
                      ),
                    ),
                  );
                },
              ),
              MenuListTile(
                text: "Clubs",
                onTap: () {
                  Navigator.push (
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Clubs(
                        pageName: "Clubs",
                      ),
                    ),
                  );
                },
              ),
              MenuListTile(
                text: "Coaches",
                onTap: () {
                  Navigator.push (
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Coaches(
                        pageName: "Coaches",
                      ),
                    ),
                  );
                },
              ),

              // space between sections
              Container(
                margin: const EdgeInsets.only(top: 10),
              ),

              MenuListTile(
                text: "News",
                onTap: () {
                  Navigator.push (
                    context,
                    MaterialPageRoute(
                      builder: (context) => const News(
                        pageName: "News",
                      ),
                    ),
                  );
                },
              ),

              // MenuListTile(
              //   text: "Videos",
              //   onTap: () {
              
              //   },
              // ),


            ],
          )
        ),
        backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
      )
      
    );
  
  }
}