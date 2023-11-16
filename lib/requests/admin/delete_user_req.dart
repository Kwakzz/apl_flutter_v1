import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to delete a user.
/// The arguments is the user's id as a JSON string.
Future <Map<String, dynamic>> deleteUser (String userIdJson) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/user/delete.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: userIdJson
    );
 
    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': "Account deleted successfully"
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Failed to delete account"
      };

      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Failed to delete user"
    };
    
    return result;
  }

}
