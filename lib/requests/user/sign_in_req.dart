import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../helper_classes/user.dart';
import '../../helper_classes/user_preferences.dart';
import '../api_uri.dart';


enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class AuthProvider with ChangeNotifier {

  Status _loggedInStatus = Status.notLoggedIn;

  Status get loggedInStatus => _loggedInStatus;


  /// This function sends a POST request to the API to sign in the user.
  /// The argument is a json of the user's sign in details.
  /// The response is a JSON string containing the user's details.
  Future<Map<String, dynamic>> login(String signInDetailsJson) async {

    Map<String, dynamic> result;

    _loggedInStatus = Status.authenticating;
    notifyListeners();


    // RESPONSE
    try {

      final response = await http.post(
        Uri.http(domain, '$path/user/login.php'),
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: signInDetailsJson
      );

      if (response.statusCode == 200) {


        // convert response body to map
        // this is the user's details
        final Map<String, dynamic> userData = json.decode(response.body);

        // create a user object from the map
        User user = User.fromJson(userData);

        // save the user's details to shared preferences
        // this is so that the user can be automatically logged in the next time they open the app.
        UserPreferences().saveUser(user); 

        // set the user's status to logged in
        _loggedInStatus = Status.loggedIn;
        notifyListeners();

        result = {
          'status': true, 
          'message': 'Successful', 
          'user': user
        };
      
        return result;
      
      }
       

      if (response.statusCode == 401) {

        // set the user's status to not logged in
        _loggedInStatus = Status.notLoggedIn;
        notifyListeners();

        result = {
          'status': false,
          'message': "Incorrect email or password"
        };
 
      }
         
      else {

        // set the user's status to not logged in
        _loggedInStatus = Status.notLoggedIn;
        notifyListeners();

        result = {
          'status': false,
          'message': "An error occurred"
        };

      }
      
      return result;

    }
    catch (e) {
      return result = {
        'status': false,
        'message': "An error occurred"
      };
    }

    
  }
}
