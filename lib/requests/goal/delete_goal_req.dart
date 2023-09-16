import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to delete a goal.
/// The arguments are the goals details as a JSON string.
/// The JSON string has the following parameters:
/// - goal_id
Future <Map<String, dynamic>> deleteGoal (String goalDetails) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/goal/delete.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: goalDetails
    );
 
    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': "Goal deleted successfully"
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Failed to delete goal"
      };
      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Failed to delete goal"
    };
    return result;
  }

}
