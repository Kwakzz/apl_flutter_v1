import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to delete a team from a table.
Future<Map<String, dynamic>> deleteStandingsTeam(standingsTeamDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/standings/delete_team.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: standingsTeamDetails
    );

    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': 'Team deleted from standings successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to delete team from standings'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to delete team from standings'
    };

    return result;
  }
}
