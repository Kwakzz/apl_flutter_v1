import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to add a starting XI to a particular game. The only parameter is the game id.
Future<Map<String, dynamic>> addStartingXI(startingXIDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/starting_xi/add.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: startingXIDetails
    );

    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': 'Starting XI added successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to add starting XI'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to add starting XI'
    };

    return result;
  }
}
