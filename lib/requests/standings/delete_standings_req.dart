import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to delete a table.
Future<Map<String, dynamic>> deleteStandings(standingsDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/standings/delete.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: standingsDetails
    );

    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': 'Table deleted successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to delete table'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to delete table'
    };

    return result;
  }
}
