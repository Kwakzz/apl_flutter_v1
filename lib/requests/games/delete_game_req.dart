import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to delete a game 
Future<Map<String, dynamic>> deleteGame(gameDetails) async {

  Map<String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/game/delete.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: gameDetails
    );

    if (response.statusCode == 204) {

      result = {
        'status': true,
        'message': 'Game deleted successfully'
      };

      return result;

    }

    else {
      result = {
        'status': false,
        'message': 'Game not deleted'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Game not deleted'
    };

    return result;
  }
}
