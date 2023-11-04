import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the teams.
/// The API function retrieves a json string of all the teams.
/// An example of the response is:
/// [{"team_id":1,"team_name":"Elite","team_logo_url":null,"team_name_abbrev":"ELI"},{"team_id":2,"team_name":"Legends United","team_logo_url":null,"team_name_abbrev":"LU"}...]
/// The function returns a list of team names, not the entire json string.

Future<List<String>> getTeamNames () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/team/get_teams.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final teams = jsonDecode(response.body) as List<dynamic>;
      final teamNames = teams.map((team) => team['team_name'] as String).toList();
      return teamNames;
    }

    else {
      throw Exception('Failed to load teams');
    }
    
  }

  catch (e) {
    return [];
  }

}

/// This function sends a GET request to the server to get all the teams.
/// The API function retrieves a json string of all the teams.
/// An example of the response is:
/// [{"team_id":1,"team_name":"Elite","team_logo_url":null,"team_name_abbrev":"ELI"},{"team_id":2,"team_name":"Legends United","team_logo_url":null,"team_name_abbrev":"LU"}...]
/// This function returns the entire json string.
Future<List<Map<String, dynamic>>> getTeams() async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/team/get_teams.php'),
      headers: <String, String>{
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
