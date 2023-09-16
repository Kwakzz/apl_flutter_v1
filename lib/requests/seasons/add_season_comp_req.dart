import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to add a competition 
/// to a particular season.
Future<Map<String, dynamic>> addSeasonComp(seasonCompDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/season/add_comp.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: seasonCompDetails
    );

    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': "Competition added successfully"
      };

      return result;
    }
  

    else {
      result = {
        'status': false,
        'message': "Error adding competition"
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': "Error adding competition"
    };

    return result;
  }
}
