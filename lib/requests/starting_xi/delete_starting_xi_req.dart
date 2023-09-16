import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to delete a starting XI. The only parameter is the game id.
Future<Map<String, dynamic>> deleteStartingXI(startingXIDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(
        domain, 
        '$path/starting_xi/delete.php'
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: startingXIDetails
    );

    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': 'Starting XI deleted successfully'
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to delete starting XI'
      };
      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to delete starting XI'
    };
    return result;
  }
}
