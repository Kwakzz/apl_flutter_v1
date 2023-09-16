import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get the number of games played by a women's team

Future <Map<String, dynamic>> getNoOfGamesPlayedByWomensTeam (teamId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/game/get_no_played_by_womens_team.php', 
        {'team_id': teamId.toString()}
      ),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty map.
      if (response.body.isEmpty) return {};

      final wins = jsonDecode(response.body);
      return Map<String, dynamic>.from(wins);  
    }

    else {
      throw Exception('Failed to load number of games played by women\'s team');
    }
    
  }

  catch (e) {
    return {};
  }

}

