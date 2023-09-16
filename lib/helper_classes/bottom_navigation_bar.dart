import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavigationBar extends StatelessWidget {

  CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap, 
    required selectedItemColor,
    required this.items,
  });

  int currentIndex;
  final ValueChanged<int> onTap;
  List<BottomNavigationBarItem> items;
  Color selectedItemColor = const Color.fromARGB(255, 0, 53, 91);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, 
      onTap: onTap,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: Colors.grey,
      items: items,
      selectedLabelStyle: GoogleFonts.montserrat(
        fontSize: 11,
        color: const Color.fromARGB(255, 0, 53, 91),
        fontWeight: FontWeight.w400,
      ),
      selectedIconTheme: const IconThemeData(
        color: Color.fromARGB(255, 0, 53, 91),
        size: 25,
      ),
  
    );
  }
}