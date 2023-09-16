import 'dart:async';
import 'package:apl/homepage.dart';
import 'package:apl/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchScreen extends StatefulWidget {

  LaunchScreen(
    {
      super.key
    }
  );

  @override
  State<StatefulWidget> createState() => LaunchScreenState();

}

class LaunchScreenState extends State<LaunchScreen> {

  bool isLoggedIn = false;

  void checkLoggedInStatus() async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();
  
    isLoggedIn = prefs.containsKey('email_address');

  }

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {

    // Navigate to the welcome screen after a delay
    Future.delayed(
      const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => 
          // If the user is logged in, go to the home screen, otherwise go to the welcome screen
          isLoggedIn ? const HomePage() :
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