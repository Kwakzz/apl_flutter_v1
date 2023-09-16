import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to get the number of losses for a men's team in a season competition.
Future<Map<String, dynamic>> getTeamSeasonCompLosses(
  int teamId, 
  seasonId, 
  int competitionId
) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/standings/get_team_losses.php' , 
      {
        'team_id': teamId.toString(),
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
      if (response.body.isEmpty) return {};
      
      final noOfLosses = jsonDecode(response.body);
      return Map<String, dynamic>.from(noOfLosses);
    } 
    else {
      throw Exception("Failed to load the number of losses");
    }

  } 
  
  catch (e) {
    print(e);
    return {};
  }
}
