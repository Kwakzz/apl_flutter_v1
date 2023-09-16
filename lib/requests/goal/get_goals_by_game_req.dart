import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the goals scored in a game

Future<List<Map<String, dynamic>>> getGoalsByGame (gameId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/goal/get_by_game.php', 
        {
          'game_id': gameId.toString()
        }
      ),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];

      final goals = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(goals);  
    }

    else {
      throw Exception('Failed to load goals');
    }
    
  }

  catch (e) {
    return [];
  }

}

