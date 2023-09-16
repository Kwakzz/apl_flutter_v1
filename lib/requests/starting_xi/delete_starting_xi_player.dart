import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to remove a player from a starting XI. The only parameters are the starting XI id and the player id.
Future<Map<String, dynamic>> removeStartingXIPlayer(playerDetails) async {

  Map <String, dynamic> result = {};

  try {
    final response = await http.post(
      Uri.http(domain, '$path/starting_xi/remove_player.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: playerDetails
    );

    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': 'Player removed from starting XI successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to remove player from starting XI'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to remove player from starting XI'
    };

    return result;
  }
}
