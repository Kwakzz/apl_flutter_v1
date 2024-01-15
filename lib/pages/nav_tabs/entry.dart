
import 'package:apl/pages/nav_tabs/admin.dart';
import 'package:apl/helper_classes/user_preferences.dart';
import 'package:apl/pages/nav_tabs/latest.dart';
import 'package:apl/pages/nav_tabs/pl.dart';
import 'package:apl/pages/nav_tabs/stats.dart';
import 'package:apl/pages/nav_tabs/more.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper_classes/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: '',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.sports_soccer,
        ),
        label: '',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.bar_chart,
        ),
        label: '',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.more_horiz,
        ),
        label: '',
      ),
    ];

    // If the user is logged in and is an admin, add the admin icon to the bottom navigation bar.
    if (isLoggedIn && isAdmin) {

      bottomNavBarItems.add(
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.admin_panel_settings,
          ),
          label: '',
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: widgetOptions.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: bottomNavBarItems,
          selectedIconTheme: const IconThemeData(
            size: 40,
          ),
          backgroundColor: Colors.red,
      
        )
      ),
    );
  }

}
