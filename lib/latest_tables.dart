
import 'package:flutter/material.dart';

import 'helper_classes/text.dart';



class LatestTables extends StatefulWidget {
  const LatestTables(
    {
      super.key,
      required this.leagueTables,
      required this.gameweeksMap,
      required this.viewAllTablesOnPressed
    }
  );

  final List<Widget> leagueTables;
  final List<Map<String, dynamic>> gameweeksMap;
  final Function () ? viewAllTablesOnPressed;


  @override
  _LatestTablesState createState() => _LatestTablesState();
}

class _LatestTablesState extends State<LatestTables> {


  @override
  Widget build(BuildContext context) {

    if (widget.leagueTables.isEmpty){
      return Container();
    }

    return Container(
      // width
      decoration: const BoxDecoration(
        color: Colors.white,        
      ),
      margin: const EdgeInsets.only(top:16, bottom: 16),
      child: Column(         
        children: [
          
            ...widget.leagueTables,

              // "View Tables" button
              // if gameweeksMap is empty, don't show the button
                  
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: widget.viewAllTablesOnPressed,
                  child: const AppText(
                    text: 'View all tables',
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 10,
                )
              ],
            )
              ],
            ),
          );
  }
}