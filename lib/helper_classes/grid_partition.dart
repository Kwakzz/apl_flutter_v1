import 'package:apl/helper_classes/text.dart';
import 'package:flutter/material.dart';

/// This class is used to create a grid partition.  
/// It is used in the Grid class.
class GridPartition extends StatelessWidget {
  
  const GridPartition(
    {
      super.key,
      required this.child
    }
  );

  // The child of the grid partition
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 100,
      child: child,
    );
  }
}

class MenuGridPartition extends StatelessWidget {
  
  const MenuGridPartition(
    {
      super.key,
      this.icon,
      required this.text
    }
  );

  // The child of the grid partition
  final Icon? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 100,
      child: 
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Column (
          children: [   
            AppText(
              text: text, 
              fontWeight: FontWeight.w400, 
              fontSize: 20, 
              color: Colors.black
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Icon(
                icon?.icon,
                color: Colors.black,
                size: 80,
              )
            ),
          ],
        )
      )
    );
  }
}