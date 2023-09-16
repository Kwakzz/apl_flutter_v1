import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the goals scored by a player in a season.

Future<List<Map<String, dynamic>>> getSeasonCompTopAssistProviders (seasonId, competitionId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/assist/get_season_comp_top_assist_providers.php', 
        {
          'season_id': seasonId.toString(),
          'competition_id': competitionId.toString()
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

      final assists = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(assists);  
    }

    else {
      throw Exception('Failed to load assists');
    }
    
  }

  catch (e) {
    return [];
  }

}

