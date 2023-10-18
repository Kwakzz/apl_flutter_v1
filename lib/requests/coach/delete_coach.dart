import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to delete a coach.
/// The argument is the coach's id as a JSON string.
Future <Map<String, dynamic>> deleteCoach (String playerIdJson) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/coach/delete.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: playerIdJson
    );
 
    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': "Coach deleted successfully"
      };

      return result;
    }
  

    else {
      result = {
        'status': false,
        'message': "Failed to delete coach"
      };

      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Failed to delete coach"
    };

    return result;
  }

}
