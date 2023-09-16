import 'package:http/http.dart' as https;
import 'api_uri.dart';


/// This function sends a POST request to the API to check whether a user's account exists. It'll be used for email validation. The only argument is the user's email address as a JSON string.
Future <bool> ifUserExists (String emailAddress) async {

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/user/if_exists.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: emailAddress
    );

    // If the user exists
    if (response.statusCode == 200) {
      return true;
    }


    // If the API returns anything else, throw an exception.
    else {
      throw Exception('Failed to load data');}
  }

  catch (e) {
    print(e);
    return false;
  }

}
