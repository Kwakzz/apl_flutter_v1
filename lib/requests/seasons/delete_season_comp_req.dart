import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a POST request to the server to delete a competition happening a particular season.
Future<Map<String, dynamic>> deleteSeasonComp(seasonCompDetails) async {

  Map <String, dynamic> result = {};
  
  try {
    final response = await http.post(
      Uri.http(domain, '$path/season/delete_comp.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: seasonCompDetails
    );

    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': 'Season competition deleted successfully'
      };

      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'Failed to delete season competition'
      };

      return result;
    }

  } 
  
  catch (e) {
    result = {
      'status': false,
      'message': 'Failed to delete season competition'
    };

    return result;
  }
}
