import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/pl/womens_results_view.dart';
import 'package:apl/pl/mens_results_view.dart';
import 'package:flutter/material.dart';



class Results extends StatefulWidget {
  const Results(
    {
      super.key,
      required this.pageName,
    }
  );

  final String pageName;

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

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
              MensResultsView(),     
              WomensResultsView(),
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
    );
  }
}