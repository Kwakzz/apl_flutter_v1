import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to add a game to a gameweek.
Future<Map<String, dynamic>> addLeagueGame(gameDetails) async {

  Map<String, dynamic> result = {};  
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/game/add.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: gameDetails
    );

    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': 'Game added successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Game not added'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Game not added'
    };

    return result;
  }
}
