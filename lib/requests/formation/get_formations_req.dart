import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the formations.

Future<List<Map<String, dynamic>>> getFormations () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/formation/get_all.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];

      final formations = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(formations);  
    }

    else {
      throw Exception('Failed to load formations');
    }
    
  }

  catch (e) {
    return [];
  }

}
