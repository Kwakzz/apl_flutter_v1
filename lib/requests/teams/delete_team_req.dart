import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to delete a team.
/// The arguments are the team's details as a JSON string.
Future <Map<String, dynamic>> deleteTeam (String teamDetails) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/team/delete.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: teamDetails
    );
 
    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': "Team deleted successfully"
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Failed to delete team"
      };
      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Failed to delete team"
    };
    return result;
  }

}
