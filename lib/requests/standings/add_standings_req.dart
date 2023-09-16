import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to add a table to a season competition.
Future<Map<String, dynamic>> addStandings(standingsDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/standings/add.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: standingsDetails
    );

    if (response.statusCode == 201) {

      result = {
        'status': true,
        'message': 'Standings added successfully'
      };

      return result;
    }
 
    else {
      result = {
        'status': false,
        'message': 'Failed to add standings'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to add standings'
    };

    return result;
  }
}
