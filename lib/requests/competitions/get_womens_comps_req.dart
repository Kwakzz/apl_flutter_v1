import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the women's competitions.
/// The API function retrieves a json string of all the competitions.
Future<List<Map<String, dynamic>>> getWomensCompetitions() async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/competition/get_womens.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];
      
      final competitions = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(competitions);
    } 
    else {
      throw Exception("Failed to load competitions");
    }

  } 
  
  catch (e) {
    return [];
  }
}
