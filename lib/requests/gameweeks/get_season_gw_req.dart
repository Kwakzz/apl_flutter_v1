import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the gameweeks in a particular season.
/// The API function retrieves a json string of all the gameweeks for that season.
/// The argument is the season id.
Future<List<Map<String, dynamic>>> getSeasonGameweeks(int seasonId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/gameweek/get_season_gw.php' , {
        'season_id': seasonId.toString()
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];
      
      final gameweeks = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(gameweeks);
    } 
    else {
      throw Exception("Failed to load gameweeks");
    }

  } 
  
  catch (e) {
    return [];
  }
}
