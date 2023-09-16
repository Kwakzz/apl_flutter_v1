import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to get the standings for a season competition.
Future<List<Map<String, dynamic>>> getSeasonCompStandingsWithoutTeams(
  int seasonId, int competitionId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/standings/get_season_comp_standings_without_teams.php' , 
      {
        'season_id': seasonId.toString(),
        'competition_id': competitionId.toString()
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];
      
      final standings = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(standings);
    } 
    else {
      throw Exception("Failed to load standings");
    }

  } 
  
  catch (e) {
    print(e);
    return [];
  }
}
