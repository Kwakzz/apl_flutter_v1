import 'package:flutter/material.dart';

class AppBarBottomRow extends StatelessWidget {

  AppBarBottomRow({
    super.key,
    required this.children
  });

  List<Widget> children;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color.fromARGB(255, 0, 53, 91),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      )
    );
  }
}