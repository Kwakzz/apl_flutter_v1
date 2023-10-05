import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to update a team's details in a table.
Future<Map<String, dynamic>> updateStandings(standingsTeamDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/standings/update.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: standingsTeamDetails
    );

    if (response.statusCode == 200) {
        
        result = {
          'status': true,
          'message': 'Standings updated successfully'
        };
  
        return result;
        
      }
  
      else {
          
          result = {
            'status': false,
            'message': 'Failed to update standings'
          };
    
          return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to update standings'
    };

    return result;
  }
}
