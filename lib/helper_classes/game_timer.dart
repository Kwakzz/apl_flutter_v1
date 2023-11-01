import 'dart:async';

import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {

  final Map <String, dynamic> game;

  const GameTimer(
    {
      super.key, 
      required this.game
    }
  );

  @override
  _GameTimerState createState() => _GameTimerState();

  
}

class _GameTimerState extends State<GameTimer> {

  late Timer _timer;
  TimeOfDay _currentTime = TimeOfDay.now();
  late TimeOfDay _endTime;
  bool _isTimeUp = false;
  bool _isGameStarted = false;

  @override
  void initState() {
    super.initState();

    _endTime = widget.game['start_time'] + const Duration(minutes: 90);

    if (_currentTime.hour >= widget.game['startTime'].hour && _currentTime.minute >= widget.game['startTime'].minute && _currentTime.hour <= widget.game['endTime'].hour && _currentTime.minute <= widget.game['endTime'].minute) {
      setState(() {
        _isGameStarted = true;
        
      });
    }

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _isTimeUp ? Colors.red : Colors.black,
      ),
    );
  }
}