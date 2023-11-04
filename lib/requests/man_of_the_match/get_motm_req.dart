import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get the man of the match for a game. 
Future<Map<String, dynamic>> getMOTM (int gameId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/man_of_the_match/get.php' , 
      {
        'game_id': gameId.toString()
      }
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty map.
      if (response.body.isEmpty) return {};
      
      final motm = jsonDecode(response.body);
      return Map<String, dynamic>.from(motm);
    } 
    else {
      throw Exception("Failed to load man of the match");
    }

  } 
  
  catch (e) {
    return {};
  }
}
