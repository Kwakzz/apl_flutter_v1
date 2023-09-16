import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to delete a season.
/// The argument is the season's id as a JSON string.
Future <Map<String, dynamic>> deleteSeason (String seasonIdJson) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/season/delete.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: seasonIdJson
    );
 
    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': "Season deleted successfully"
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Season not deleted"
      };

      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Season not deleted"
    };

    return result;
  }

}
