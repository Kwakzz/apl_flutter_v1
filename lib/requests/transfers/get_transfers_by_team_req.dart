import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all transfers.
Future<List<Map<String, dynamic>>> getTransfersByTeam(int teamId) async {
  
  try {
    final response = await http.get(
      Uri.http(
        domain, 
        '$path/transfer/get_by_team.php' ,
        {'team_id': teamId.toString()}
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return [];
      
      final transfers = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(transfers);
    } 
    else {
      throw Exception("Failed to load transfers");
    }

  } 
  
  catch (e) {
    print(e);
    return [];
  }
}
