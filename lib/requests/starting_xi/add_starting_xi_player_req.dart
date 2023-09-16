import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to add a player to a team's starting XI for a particular game. The parameters are the xi id, the player id and position id.
Future<Map<String, dynamic>> addStartingXIPlayer(startingXIPlayerDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/starting_xi/add_player.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: startingXIPlayerDetails
    );

    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': 'Player added to starting XI successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to add player to starting XI'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to add player to starting XI'
    };

    return result;
  }
}
