import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to get the teams in a table
Future<List<Map<String, dynamic>>> getStandingsTeams(
  int standingsId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/standings/get_teams.php' , 
      {
        'standings_id': standingsId.toString(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];
      
      final standingsTeams = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(standingsTeams);
    } 
    else {
      throw Exception("Failed to load standings teams");
    }

  } 
  
  catch (e) {
    print(e);
    return [];
  }
}
