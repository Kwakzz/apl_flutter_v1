
import 'package:apl/admin_pages/players/mens_players.dart';
import 'package:apl/admin_pages/players/womens_players.dart';
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:flutter/material.dart';


class Players extends StatefulWidget {
  const Players({super.key});

  @override
  _PlayersState createState() => _PlayersState();
}

class _PlayersState extends State<Players> {


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

              // men's players
              MensPlayers(),

              // women's players
              WomensPlayers() 
            ]
          ),
        ),
      ),
    );
  }
}