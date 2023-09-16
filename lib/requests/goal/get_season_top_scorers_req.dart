import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the goals scored by a player in a season.

Future<List<Map<String, dynamic>>> getSeasonTopScorers (seasonId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/goal/get_season_top_scorers.php', 
        {
          'season_id': seasonId.toString()
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

      final players = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(players);  
    }

    else {
      throw Exception('Failed to load players');
    }
    
  }

  catch (e) {
    return [];
  }

}

