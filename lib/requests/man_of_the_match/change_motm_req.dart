import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to change the man of the match for a game.
/// The arguments are the game id and player id as a JSON string.
Future <Map<String, dynamic>> changeManOfTheMatch (String playerAndGame) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/man_of_the_match/change.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: playerAndGame
    );
 
    if (response.statusCode == 200) {
      
      result = {
        'status': true,
        'message': 'MOTM changed successfully'
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


