import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request for all APL men's players
Future<List<Map<String, dynamic>>> getMensPlayers () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_men.php'),
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

/// This function sends a GET request to the server to get all the active male players.
/// The API function retrieves a json string of all the active male players.
/// An example of the response is:
/// [{"fname": "Kwaku", "lname": "Osafo",..}]

Future<List<Map<String, dynamic>>> getActiveMensPlayers () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_active_men.php'),
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


/// This function sends a get request to the API to obtain the list of retired male players.
Future<List<Map<String, dynamic>>> getRetiredMensPlayers () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_retired_men.php'),
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


/// This function sends a get request to the API to obtain male players with a user account.
Future<List<Map<String, dynamic>>> getMensPlayersWithAccount () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_male_players_with_acc.php'),
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


/// This function sends a get request to the API to obtain male players without a user account.
Future<List<Map<String, dynamic>>> getMensPlayersWithoutAccount () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_male_players_without_acc.php'),
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