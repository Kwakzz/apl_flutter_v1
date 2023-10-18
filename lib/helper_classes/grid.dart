import 'package:flutter/material.dart';

/// This class is used to create a grid.
/// It is used in the SelectTeam class.
/// It is used to display the teams in a grid.
/// The grid is scrollable.
/// The grid is made up of GridPartitions.
/// The grid has 2 columns.
/// The grid has 3 rows.
class Grid extends StatelessWidget {

  Grid (
    {
      super.key,
      required this.crossAxistCount,
      required this.partitions
    }
  );
  
  // The number of columns in the grid
  final int crossAxistCount;
  
  // list of partitions in the grid
  List <Widget> partitions;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxistCount,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      // The children of the grid are GridPartitions
      children: partitions
    );
  }
}
