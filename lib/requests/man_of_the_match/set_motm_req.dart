import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to set the man of the match for a game.
/// The arguments are the game id and player id as a JSON string.
Future <Map<String, dynamic>> setManOfTheMatch (String playerAndGame) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/man_of_the_match/set.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: playerAndGame
    );
 
    if (response.statusCode == 201) {
      
      result = {
        'status': true,
        'message': 'MOTM set successfully'
      };

      return result;
    }
    
    else {
              
      result = {
        'status': false,
        'message': 'Failed to set MOTM'
      };
    
        return result;  

    }
  }
  
  catch (e) {
    
    result = {
      'status': false,
      'message': 'Failed to set MOTM'
    };
  
    return result;
  }

}


