import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the stages of a tournament.

Future<List<Map<String, dynamic>>> getStages () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/stage/get_all.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final stages = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(stages);  
    }

    else {
      throw Exception('Failed to load stages');
    }
    
  }

  catch (e) {
    return [];
  }

}