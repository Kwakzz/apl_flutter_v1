import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to add a new goal.
/// The arguments are the goals details as a JSON string.
/// The JSON string has the following parameters:
/// - player_id
/// - game_id
/// - minute_scored
/// - team_id
Future <Map<String, dynamic>> addGoal (String goalDetails) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/goal/add.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: goalDetails
    );
 
    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': "Goal added successfully"
      };
      return result;
    }
    

    else {
      result = {
        'status': false,
        'message': "Failed to add goal"
      };
      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Failed to add goal"
    };
    return result;
  }

}
