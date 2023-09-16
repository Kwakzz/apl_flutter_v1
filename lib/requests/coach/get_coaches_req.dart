import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the coaches.
/// The API function retrieves a json string of all the coaches.
/// An example of the response is:
/// [{"fname": "Kwaku", "lname": "Osafo",..}]

Future<List<Map<String, dynamic>>> getCoaches () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/coach/get_coaches.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];

      final coaches = jsonDecode(response.body);
      final filteredCoaches = coaches.map((coach) {
        coach.remove('activation_code');
        coach.remove('activation_expiry');
        coach.remove('activated_at');
        return coach;
      }).toList();
      return filteredCoaches.cast<Map<String, dynamic>>();
    }

    else {
      throw Exception('Failed to load coaches');
    }
    
  }

  catch (e) {
    print (e);
    return [];
  }

}
