import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get a coach. 
Future<Map<String, dynamic>> getCoach(int coachId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/coach/get_coach.php' , 
      {
        'coach_id': coachId.toString()
      }
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return {};
      
      final coach = jsonDecode(response.body);
      return Map<String, dynamic>.from(coach);
    } 
    else {
      throw Exception("Failed to load coach");
    }

  } 
  
  catch (e) {
    return {};
  }
}
