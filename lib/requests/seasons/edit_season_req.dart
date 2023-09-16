import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to edit a season.
Future<Map<String, dynamic>> editSeason(seasonDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/season/edit.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: seasonDetails
    );

    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': 'Season edited successfully'
      };
      
      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to edit season'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to edit season'
    };

    return result;
  }
}
