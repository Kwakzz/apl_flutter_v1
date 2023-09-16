import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the competition names
/// It retrieves a json string of all the competition names.
Future<List<String>> getDistinctCompNames() async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/competition/get_distinct_comps.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];
      
      final comps = jsonDecode(response.body) as List<dynamic>;
      final compNames = comps.map((comp) => comp['competition_name'] as String).toList();
      return compNames;
    } 

    else {
      throw Exception("Failed to load competition names");
    }

  } 
  
  catch (e) {
    return [];
  }
}
