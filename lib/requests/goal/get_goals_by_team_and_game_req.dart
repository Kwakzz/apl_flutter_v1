import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the goals scored by a team in a game

Future<List<Map<String, dynamic>>> getGoalsByTeamAndGame (teamId, gameId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/goal/get_by_team_and_game.php', 
        {'team_id': teamId.toString(),
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

