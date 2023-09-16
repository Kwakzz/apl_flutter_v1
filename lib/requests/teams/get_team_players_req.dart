import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the players in a team.
/// The API function retrieves a json string of all the players in the team.
/// An example of the response is:
/// [{"player_id":3,"user_id":null,"fname":"Daniel","lname":"Nkansah","date_of_birth":"2002-07-12","position_id":11,"team_id":1,"height":177,"weight":70,"year_group":2024,"gender":"male","is_retired":0}, ...]
/// The argument is the team id.
Future<List<Map<String, dynamic>>> getTeamPlayers(int teamId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/team/get_team_players.php' , {'team_id': teamId.toString()}),
      headers: <String, String>{
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
      throw Exception('Failed to load data');
    }

  } 
  
  catch (e) {
    print(e);
    return [];
  }
}


Future<List<Map<String, dynamic>>> getActiveMensTeamPlayers(int teamId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/team/get_active_men.php' , {'team_id': teamId.toString()}),
      headers: <String, String>{
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
      throw Exception('Failed to load data');
    }

  } 
  
  catch (e) {
    print(e);
    return [];
  }
}

Future<List<Map<String, dynamic>>> getActiveWomensTeamPlayers(int teamId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/team/get_active_women.php' , {'team_id': teamId.toString()}),
      headers: <String, String>{
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
      throw Exception('Failed to load data');
    }

  } 
  
  catch (e) {
    print(e);
    return [];
  }
}

Future<List<Map<String, dynamic>>> getRetiredMensTeamPlayers(int teamId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/team/get_retired_men.php' , {'team_id': teamId.toString()}),
      headers: <String, String>{
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
      throw Exception('Failed to load data');
    }

  } 
  
  catch (e) {
    print(e);
    return [];
  }
}

Future<List<Map<String, dynamic>>> getRetiredWomensTeamPlayers(int teamId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/team/get_retired_women.php' , {'team_id': teamId.toString()}),
      headers: <String, String>{
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
      throw Exception('Failed to load data');
    }

  } 
  
  catch (e) {
    print(e);
    return [];
  }
}