import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to edit a game 
Future<Map<String, dynamic>> editGame(gameDetails) async {

  Map<String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/game/edit.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: gameDetails
    );

    if (response.statusCode == 200) {
        
        result = {
          'status': true,
          'message': 'Game edited successfully'
        };
  
        return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Game not edited'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Game not edited'
    };

    return result;
  }
}
