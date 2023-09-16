import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the API to reset a user's password. It sends the user's email address as a JSON string.
Future <Map<String, dynamic>> resetPassword (String emailAddress) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await http.post(
      Uri.http(domain, '$path/user/initialize_password_reset.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: emailAddress
    );
 
    if (response.statusCode == 201)  {

      result = {
        'status': true,
        'message': 'A password reset link has been sent to your email. Check your email for further instructions'
      };

      return result;

    }

    if (response.statusCode == 400) {
      result = {
        'status': false,
        'message': 'You entered an invalid email address'
      };

      return result;
    }

    if (response.statusCode == 401) {
      result = {
        'status': false,
        'message': 'You entered an invalid email address'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Password reset link not sent'
      };

      return result;
    }

    
  }


  catch (e) {

    result = {
      'status': false,
      'message': 'Password reset link not sent'
    };

    return result;
  }

}
