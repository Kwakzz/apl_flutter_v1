import 'package:apl/stats/mens_top_assist_providers.dart';
import 'package:apl/stats/mens_top_scorers.dart';
import 'package:apl/stats/womens_top_assist_providers.dart';
import 'package:apl/stats/womens_top_scorers.dart';
import 'package:flutter/material.dart';
import '../../../helper_classes/custom_appbar.dart';


class TopAssistProviders extends StatefulWidget {
  
  const TopAssistProviders(
    {
      super.key,
    }
  );


  @override
  _TopAssistProvidersState createState() => _TopAssistProvidersState();
}

class _TopAssistProvidersState extends State<TopAssistProviders> {




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
            pageName: "Assists",
            icon: const Icon(Icons.arrow_back),
            prevContext: context,
            myTabs: myTabs,  
          ),
          body: const TabBarView(
            children: [
              MensTopAssistProviders(),
              WomensTopAssistProviders()
            ]
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      
    );
  }
}