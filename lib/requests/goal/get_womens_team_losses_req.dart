import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the losses by a women's team.

Future <Map<String, dynamic>> getWomensTeamTotalNoOfLosses (teamId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/goal/get_womens_team_losses.php', 
        {'team_id': teamId.toString()}
      ),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty map.
      if (response.body.isEmpty) return {};

      final wins = jsonDecode(response.body);
      return Map<String, dynamic>.from(wins);  
    }

    else {
      throw Exception('Failed to load losses');
    }
    
  }

  catch (e) {
    return {};
  }

}

