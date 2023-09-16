import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to delete a gameweek.
Future<Map<String, dynamic>> deleteGameweek(gameweekDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/gameweek/delete.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: gameweekDetails
    );

    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': 'Gameweek deleted successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to delete gameweek'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to delete gameweek'
    };

    return result;
  }
}
