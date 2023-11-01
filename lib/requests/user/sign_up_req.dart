import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the API to register a new user.
/// The arguments are the user's personal details as a JSON string.
Future <Map<String, dynamic>> submitNewUserData (String personalDetails) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await http.post(
      Uri.http(domain, '$path/user/sign_up.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: personalDetails
    );
 
    if (response.statusCode == 201)  {

      result = {
        'status': true,
        'message': 'User created successfully'
      };

      return result;

    }

    if (response.statusCode == 409) {
      result = {
        'status': false,
        'message': 'The email address is already in use.'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'User not created'
      };

      return result;
    }

    
  }


  catch (e) {

    result = {
      'status': false,
      'message': 'User not created'
    };

    return result;
  }

}
