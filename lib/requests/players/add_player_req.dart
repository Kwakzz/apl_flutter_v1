import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to register a new player.
/// The arguments are the players details as a JSON string.
Future <Map<String, dynamic>> addPlayer (String personalDetails) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/player/add.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: personalDetails
    );
 
    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': "Player added successfully"
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Error adding player"
      };
      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Error adding player"
    };
    return result;
  }

}
