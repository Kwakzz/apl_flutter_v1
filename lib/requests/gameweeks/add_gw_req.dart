import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to add a gameweek to a season.
Future<Map<String, dynamic>> addGameweek(gameweekDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/gameweek/add.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: gameweekDetails
    );

    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': 'Gameweek added successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to add gameweek'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to add gameweek'
    };

    return result;
  }
}
