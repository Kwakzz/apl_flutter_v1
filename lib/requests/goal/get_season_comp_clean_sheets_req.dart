import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get the teams with the most clean sheets in a season and competition. 
Future<List<Map<String, dynamic>>> getSeasonCompTopCleanSheets (seasonId, competitionId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/goal/get_season_comp_clean_sheets.php', 
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

      final teams = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(teams);  
    }

    else {
      throw Exception('Failed to load teams');
    }
    
  }

  catch (e) {
    return [];
  }

}

