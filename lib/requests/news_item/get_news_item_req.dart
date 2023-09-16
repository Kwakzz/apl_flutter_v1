import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get a news item. 
Future<Map<String, dynamic>> getNewsItemById(int newsItemId) async {
  
  try {
    final response = await http.get(
      Uri.http(domain, '$path/news_item/get.php' , 
      {
        'news_item_id': newsItemId.toString()
      }
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the response is empty, return an empty list.
      if (response.body.isEmpty) return {};
      
      final newsItem = jsonDecode(response.body);
      return Map<String, dynamic>.from(newsItem);
    } 
    else {
      throw Exception("Failed to load news item");
    }

  } 
  
  catch (e) {
    print(e);
    return {};
  }
}
