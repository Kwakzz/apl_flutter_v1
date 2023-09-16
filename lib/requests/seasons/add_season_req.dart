import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to add a season.
Future<Map<String, dynamic>> addSeason(seasonDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/season/add.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: seasonDetails
    );

    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': 'Season added successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to add season'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to add season'
    };

    return result;
  }
}
