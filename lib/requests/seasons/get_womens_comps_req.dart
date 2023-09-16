import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the women's competitions being played in a season.
/// The API function retrieves a json string of all the women's competitions for that season.
/// An example of the response is:
/// [{"competition_id":3,"competition_name": Ashesi Premier League,"competition_abbrev":"APL", "gender": "Female"}, ...]
/// The argument is the season id.
Future<List<Map<String, dynamic>>> getWomensSeasonComps(int seasonId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/season/get_womens_comps.php' , {'season_id': seasonId.toString()}),
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
      throw Exception("Failed to load women's competitions");
    }

  } 
  
  catch (e) {
    return [];
  }
}
