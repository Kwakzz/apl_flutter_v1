import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the news items

Future<List<Map<String, dynamic>>> getAllNewsItems () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/news_item/get_all.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final newsItems = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(newsItems);  
    }

    else {
      throw Exception('Failed to load news items');
    }
    
  }

  catch (e) {
    return [];
  }

}