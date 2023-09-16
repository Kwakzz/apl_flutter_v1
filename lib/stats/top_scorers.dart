import 'package:apl/stats/mens_top_scorers.dart';
import 'package:apl/stats/womens_top_scorers.dart';
import 'package:flutter/material.dart';
import '../../../helper_classes/custom_appbar.dart';


class TopScorers extends StatefulWidget {
  
  const TopScorers(
    {
      super.key,
    }
  );


  @override
  _TopScorersState createState() => _TopScorersState();
}

class _TopScorersState extends State<TopScorers> {




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
            pageName: "Goals",
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: const TabBarView(
            children: [
              MensTopScorers(),
              WomensTopScorers()
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
    );
  }
}