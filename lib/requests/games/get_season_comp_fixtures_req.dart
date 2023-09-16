import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the games in a particular competition in a season.
Future<List<Map<String, dynamic>>> getSeasonCompFixtures(int seasonId, int competitionId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/game/get_season_comp_fixtures.php' , 
      {
        'season_id': seasonId.toString(),
        'competition_id': competitionId.toString()
      }
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];
      
      final games = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(games);
    } 
    else {
      throw Exception("Failed to load games");
    }

  } 
  
  catch (e) {
    return [];
  }
}
