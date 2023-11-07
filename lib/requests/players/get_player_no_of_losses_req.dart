import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get the number of appearances a player has made since the beginning of recorded data.
Future<Map<String, dynamic>> getPlayerNoOfLosses (playerId) async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(
        domain, 
        '$path/player/get_no_of_losses.php', 
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
      throw Exception('Failed to load player and number of losses');
    }
    
  }
  catch (e) {
    return {};
  }

}

