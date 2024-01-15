
import 'package:flutter/material.dart';

import 'helper/widgets/text.dart';



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

    if (widget.leagueTables.isEmpty || widget.gameweeksMap.isEmpty){
      return Container();
    }

    return Container(
      // width
      decoration: BoxDecoration(
        color: Colors.white, 
        border: Border.all(  
          color:  const Color.fromARGB(255, 230, 227, 227), 
          width: 1, 
        ),
        borderRadius: BorderRadius.circular(10.0),   
      ),
      margin: const EdgeInsets.only(top:16, bottom: 16, left: 10, right: 10),
      child: Column(         
        children: [
          
          ...widget.leagueTables,

          // "View Tables" button                  
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(  
                color:  const Color.fromARGB(255, 230, 227, 227), 
                width: 1, 
                // rounded border
              ),
            ),
            child: Row(
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
          )
        ],
      ),
    );
  }
}