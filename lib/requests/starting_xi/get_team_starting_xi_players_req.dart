import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get the players in a team's lineup for a particular game.
Future<List<Map<String, dynamic>>> getTeamStartingXIPlayers(int xiId) async {
  
  try {
    final response = await http.get(
      Uri.http(
        domain, 
        '$path/starting_xi/get_team_players.php' , 
        {'xi_id': xiId.toString()}
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];
      
      final comps = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(comps);
    } 
    else {
      throw Exception("Failed to load lineups");
    }

  } 
  
  catch (e) {
    return [];
  }
}
