import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to set a user's team id.
/// The arguments are the user's email address and the name of the team selected.
Future <Map<String, dynamic>> setUserTeam (String emailAddressAndTeamId) async {

  Map<String, dynamic> result;

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/user/set_user_team.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: emailAddressAndTeamId
    );
 
    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': "Successfully set user's team"
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Failed to set user's team"
      };

      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Failed to set user's team"
    };
    return result;
  }

}