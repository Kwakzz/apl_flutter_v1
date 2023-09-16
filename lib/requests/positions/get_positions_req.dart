import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the positions.
/// The API function retrieves a json string of all the positions.
/// An example of the response is:
/// [{"position_id":1,"position_name":"Goalkeeper","position_abbrev":"GK"}, {"position_id":2,"position_name":"Left Back","position_abbrev":"LB"}...]

Future<List<Map<String, dynamic>>> getPositions () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player_position/get_all.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final positions = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(positions);  
    }

    else {
      throw Exception('Failed to load data');
    }
    
  }

  catch (e) {
    return [];
  }

}

/// This function sends a GET request to the server to get all the names of the positions. They're only four: Goalkeeper, Defender, Midfielder, Forward.
/// The API function retrieves a json string of all the positions' names.:
Future<List<String>> getPositionNames () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/player_position/get_all.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final positions = jsonDecode(response.body) as List<dynamic>;
      final positionNames = positions.map((position) => position['position_name'] as String).toList();
      return positionNames;
    }

    else {
      throw Exception('Failed to load positions');
    }
    
  }

  catch (e) {
    return [];
  }

}