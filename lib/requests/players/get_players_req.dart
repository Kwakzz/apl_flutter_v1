import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the players.
/// The API function retrieves a json string of all the players.
/// An example of the response is:
/// [{"fname": "Kwaku", "lname": "Osafo",..}]

Future<List<Map<String, dynamic>>> getPlayers () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_all_players.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];

      final players = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(players);  
    }

    else {
      throw Exception('Failed to load players');
    }
    
  }

  catch (e) {
    return [];
  }

}
