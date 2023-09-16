// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the goals scored by a player.

Future <Map<String, dynamic>> getPlayerTotalGoals (playerId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/goal/get_player_total.php', 
        {'player_id': playerId.toString()}
      ),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty map.
      if (response.body.isEmpty) return {};

      final goals = jsonDecode(response.body);
      return Map<String, dynamic>.from(goals);  
    }

    else {
      throw Exception('Failed to load goals');
    }
    
  }

  catch (e) {
    return {};
  }

}

