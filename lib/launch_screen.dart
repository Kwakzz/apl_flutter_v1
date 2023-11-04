import 'dart:async';
import 'package:apl/homepage.dart';
import 'package:apl/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchScreen extends StatefulWidget {

  const LaunchScreen(
    {
      super.key
    }
  );

  @override
  State<StatefulWidget> createState() => LaunchScreenState();

}

class LaunchScreenState extends State<LaunchScreen> {

  bool isLoggedIn = false;
  bool firstTimeOpeningApp = true;


  void checkLoggedInStatus() async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();
  
    isLoggedIn = prefs.containsKey('email_address');

  }

  void checkIfFirstTimeOpeningApp () async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('first_time_opening_app')) {
      prefs.setBool('first_time_opening_app', false);
    }

    firstTimeOpeningApp = prefs.getBool('first_time_opening_app')!;
  }

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
    checkIfFirstTimeOpeningApp();
  }

  @override
  Widget build(BuildContext context) {

    // Navigate to the welcome screen after a delay
    Future.delayed(
      const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => 
          // If this is the first time opening the app, show the welcome screen
          // Otherwise, show the home page
          !firstTimeOpeningApp ? const HomePage() :
          const Welcome()),
        );
      }
    );

    // Launch screen is the APL logo on a red background
    return Scaffold(
      body: Center (
        child: Image.asset(
          'assets/splash/apl_splash.png',
          width: 200,
          height: 200,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 185, 0, 0)
    );
  }
}