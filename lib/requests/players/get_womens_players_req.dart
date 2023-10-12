import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request for all APL women's players
Future<List<Map<String, dynamic>>> getWomensPlayers () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_women.php'),
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

/// This function sends a GET request to the server to get all the active female players.
/// The API function retrieves a json string of all the active female players.
/// An example of the response is:
/// [{"fname": "Karen", "lname": "Daisy",..}]
Future<List<Map<String, dynamic>>> getActiveWomensPlayers () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_active_women.php'),
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


/// This function sends a get request to the API to obtain retired female players.
Future<List<Map<String, dynamic>>> getRetiredWomensPlayers () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_retired_women.php'),
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

/// This function sends a get request to the API to obtain female players with a user account.
Future<List<Map<String, dynamic>>> getWomensPlayersWithAccount () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_female_players_with_acc.php'),
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


/// This function sends a get request to the API to obtain female players without a user account.
Future<List<Map<String, dynamic>>> getWomensPlayersWithoutAccount () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player/get_female_players_without_acc.php'),
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
