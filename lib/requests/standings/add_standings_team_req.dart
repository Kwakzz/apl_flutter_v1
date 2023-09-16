import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to add a team to a table.
Future<Map <String, dynamic>> addStandingsTeam(standingsTeamDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/standings/add_team.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: standingsTeamDetails
    );

    if (response.statusCode == 201) {

      result = {
        'status': true,
        'message': 'Team added to standings successfully'
      };

      return result;
      
    }

    else {
        
        result = {
          'status': false,
          'message': 'Failed to add team to standings'
        };
  
        return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to add team to standings'
    };

    return result;
  }
}
