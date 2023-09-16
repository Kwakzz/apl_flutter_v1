import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get a player by id
Future<Map<String, dynamic>> getPlayerById (playerId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/player/get.php', 
        {
          'player_id': playerId.toString()
        }
      ),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty map.
      if (response.body.isEmpty) return {};

      final player = jsonDecode(response.body);
      return Map<String, dynamic>.from(player);
    }

    else {
      throw Exception('Failed to load player');
    }
    
  }
  catch (e) {
    return {};
  }

}

