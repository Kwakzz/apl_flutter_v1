import 'dart:convert';
import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to either add a new player profile or link a user to their player profile.
Future<Map<String, dynamic>> registerUserAsPlayer (String playerDetails) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/user/player_registration.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: playerDetails
    );
 
    if (response.statusCode == 200) {

      result = {
        'status': true,
        'message': "Your account has been linked to your player profile."
      };
      return result;

    }

    if (response.statusCode == 201) {

      result = {
        'status': true,
        'message': "Your player profile has been created and linked to your account."
      };
      return result;

    }



    else {
      result = {
        'status': false,
        'message': "Error registering player"
      };
      return result;

    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Error registering player"
    };
    return result;
  }

}


/// This function sends a POST request to the API to either add a new coach profile or link a user to their coach profile.
Future<Map<String, dynamic>> registerUserAsCoach (String coachDetails) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/user/coach_registration.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: coachDetails
    );
 
    if (response.statusCode == 200) {
        
        result = {
          'status': true,
          'message': "Your account has been linked to your coach profile."
        };
        return result;
  
    }

    if (response.statusCode == 201) {

      result = {
        'status': true,
        'message': "Your coach profile has been created and linked to your account."
      };
      return result;

    }

    else {
      result = {
        'status': false,
        'message': "Error registering coach"
      };
      return result;

    }

  }

  catch (e) {
    result = {
      'status': false,
      'message': "Error registering coach"
    };
    return result;
  }

}

