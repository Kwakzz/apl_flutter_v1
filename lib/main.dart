import 'package:flutter/material.dart';
import 'launch_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    home: LaunchScreen()
  ));
}
