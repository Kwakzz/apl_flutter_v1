import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the admins. Admins have the is_admin column set to 1
/// The API function retrieves a json string of all the fans.
/// An example of the response is:
/// [{"fname": "Kwaku", "lname": "Osafo",..}]

Future<List<Map<String, dynamic>>> getAdmins () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/user/get_admins.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];

      final fans = jsonDecode(response.body);
      final filteredFans = fans.map((fan) {
        fan.remove('activation_code');
        fan.remove('activation_expiry');
        fan.remove('activated_at');
        return fan;
      }).toList();
      return filteredFans.cast<Map<String, dynamic>>();
    }

    else {
      return [];
    }
    
  }

  catch (e) {
    return [];
  }

}
