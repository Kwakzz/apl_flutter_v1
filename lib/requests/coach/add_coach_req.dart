import 'dart:convert';
import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to register a new coach.
/// The arguments are the players details as a JSON string.
Future <Map<String, dynamic>> addCoach (String personalDetails) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/coach/add.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: personalDetails
    );
 
    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': "Coach added successfully."
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Failed to add coach."
      };
      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Failed to add coach."
    };
    return result;
  }

}
