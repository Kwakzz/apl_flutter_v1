
import 'package:apl/admin_pages/standings/mens_standings.dart';
import 'package:apl/admin_pages/standings/women_standings.dart';
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:flutter/material.dart';


class Standings extends StatefulWidget {
  const Standings({super.key});

  @override
  _PlayersState createState() => _PlayersState();
}

class _PlayersState extends State<Standings> {


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
            height: 60,
            pageName: "",
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: const TabBarView(
            children: [

              // men's standings
              MensStandings(),

              // women's standings
              WomensStandings() 
            ]
          ),
        ),
      ),
    );
  }
}