import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the women's games in a particular gameweek.
/// The API function retrieves a json string of all the women's games for that gameweek.
/// The argument is the gameweek id.
Future<List<Map<String, dynamic>>> getWomensGameweekGames(int gameweekId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/game/get_womens_gw_games.php' , {'gameweek_id': gameweekId.toString()}),
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
