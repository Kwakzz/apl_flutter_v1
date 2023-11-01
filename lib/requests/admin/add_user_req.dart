import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to register a new user.
/// The arguments are the user's personal details as a JSON string.
Future <Map<String, dynamic>> addUser (String personalDetails) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/user/add.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: personalDetails
    );
 
    if (response.statusCode == 201) {
      
      result = {
        'status': true,
        'message': 'User added successfully'
      };

      return result;
    }
      
    else if (response.statusCode == 409) {
  
      result = {
        'status': false,
        'message': 'Email already exists'
      };
  
      return result;
    }
  
    else {
              
      result = {
        'status': false,
        'message': 'Failed to add user'
      };
    
        return result;  

    }
  }
  
  catch (e) {
    
    result = {
      'status': false,
      'message': 'Failed to add user'
    };
  
    return result;
  }

}


