import 'package:apl/helper_classes/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Class for Custom App Bar
// ignore: must_be_immutable
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  
  @override
  Size get preferredSize => const Size.fromHeight(60);

  String pageName;
  Icon icon;
  final BuildContext prevContext;


  CustomAppbar(
    {
      super.key, 
      required this.pageName,
      required this.icon,
      required this.prevContext,
    }
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: icon,
        onPressed: () {
          // Navigate back to the previous screen by popping the current route
          Navigator.of(prevContext).pop(); 
        },
        iconSize: 16,
      ),
      title: AppText(
        text: pageName, 
        fontWeight: FontWeight.w600, 
        fontSize: 16, 
        color: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
    );
  }
}

/// Class for Custom App Bar with Tabs
// ignore: must_be_immutable
class CustomAppbarWithTabs extends StatelessWidget implements PreferredSizeWidget {
  
  @override
  Size get preferredSize => Size.fromHeight(height);

  String pageName;
  Icon icon;
  final BuildContext prevContext;
  final List<Widget> myTabs;
  // height of preferredSize 
  final double height;
  List<Widget>? actions;
  Color? color;


  CustomAppbarWithTabs(
    {
      super.key, 
      required this.pageName,
      required this.icon,
      required this.prevContext,
      required this.myTabs,
      this.color,
      this.height = 100,
      actions
    }
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: icon,
        onPressed: () {
          // Navigate back to the previous screen by popping the current route
          Navigator.of(prevContext).pop(); 
        },
        iconSize: 16,
      ),
      title: AppText(
        text: pageName, 
        fontWeight: FontWeight.w600, 
        fontSize: 16, 
        color: Colors.white,
      ),
      backgroundColor: color ?? const Color.fromARGB(255, 0, 53, 91),
      bottom: TabBar(
        tabs: myTabs,
        indicatorWeight: 2.5,
        labelStyle: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: actions,
    );
  }
}


/// Class for Custom App Bar with Tabs
// ignore: must_be_immutable
class SecondCustomAppbarWithTabs extends StatelessWidget implements PreferredSizeWidget {
  
  @override
  Size get preferredSize => const Size.fromHeight(70);

  Icon icon;
  final List<Widget> myTabs;
  List<Widget>? actions;


  SecondCustomAppbarWithTabs(
    {
      super.key, 
      required this.icon,
      required this.myTabs,
      actions
    }
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      bottom: TabBar(
        tabs: myTabs,
        indicatorWeight: 2.5,
      ),
      actions: actions,
    );
  }
}



/// Class for Custom App Bar
// ignore: must_be_immutable

class APLAppBar extends StatelessWidget implements PreferredSizeWidget {

  const APLAppBar(
    {super.key}
  );

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, 
      elevation: 0,
      toolbarHeight: 100,
      title: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Image.asset(
          'assets/logo/apl_logo.png', 
          width: 150,
          height: 70,
        )
      ),
      backgroundColor: const Color.fromARGB(255, 0, 53, 91),
    );
  }
}
