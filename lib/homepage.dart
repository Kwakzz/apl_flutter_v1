
import 'package:apl/admin.dart';
import 'package:apl/helper_classes/bottom_navigation_bar.dart';
import 'package:apl/helper_classes/user_preferences.dart';
import 'package:apl/latest.dart';
import 'package:apl/pl.dart';
import 'package:apl/stats.dart';
import 'package:apl/more.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper_classes/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  bool isAdmin = false;
  int _currentIndex = 0;

  List<Widget> widgetOptions = [
    const Latest(),
    const PL(),
    const Stats(),
    const More(),
  ];

  @override
  void initState() {
    super.initState();
    initializeWidgetOptions();
  }

  /// Checks if the user is logged in and if the user is an admin. If the user is as admin, set the isAdmin variable to true.
  Future<void> initializeWidgetOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = prefs.containsKey('email_address');
    });

    if (isLoggedIn) {
      User user = await UserPreferences().getUser();
      if (user.isAdmin == 1) {
        setState(() {
          isAdmin = true;
          widgetOptions.add(const Admin(pageName: 'Admin',));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Latest',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.sports_soccer),
        label: 'PL',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        label: 'Stats',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.more_horiz),
        label: 'More',
      ),
    ];

    // If the user is logged in and is an admin, add the admin icon to the bottom navigation bar.
    if (isLoggedIn && isAdmin) {

      bottomNavBarItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: widgetOptions[_currentIndex],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          selectedItemColor: const Color.fromARGB(255, 40, 56, 198),
          items: bottomNavBarItems,
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
