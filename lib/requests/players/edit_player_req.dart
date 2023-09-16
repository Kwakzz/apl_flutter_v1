import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to edit a player.
/// The arguments are the player's details as a JSON string.
Future <Map<String, dynamic>> editPlayer (String personalDetails) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/player/edit.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: personalDetails
    );
 
    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': "Player edited successfully"
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Error editing player"
      };
      return result;
    }

  }

  catch (e) {
    result = {
      'status': false,
      'message': "Error editing player"
    };
    return result;
  }

}
