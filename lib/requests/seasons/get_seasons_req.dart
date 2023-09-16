import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the seasons.
/// The API function retrieves a json string of all the seasons.
Future<List<Map<String, dynamic>>> getSeasons() async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/season/get_seasons.php'),
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
      throw Exception('Failed to load data');
    }

  } 
  
  catch (e) {
    return [];
  }
}
