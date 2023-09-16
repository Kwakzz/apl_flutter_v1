import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get a team's lineup for a particular game.
Future<Map<String, dynamic>> getTeamStartingXI(
  int gameId, 
  int teamId
) async {
  
  try {
    final response = await http.get(
      Uri.http(
        domain, 
        '$path/starting_xi/get_team_starting_xi.php', 
        {
          'game_id': gameId.toString(), 
          'team_id': teamId.toString()
        }
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty map.
      if (response.body.isEmpty) return {};
      
      final startingXI = jsonDecode(response.body);
      return Map<String, dynamic>.from(startingXI);
    } 
    else {
      throw Exception("Failed to load lineup");
    }

  } 
  
  catch (e) {
    return {};
  }
}
