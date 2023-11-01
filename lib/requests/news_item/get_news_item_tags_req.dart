import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_uri.dart';


/// This function sends a GET request to the server to get all the news item tags. These tags form the items in the dropdown menu for news categories in the add news item page

Future<List<Map<String, dynamic>>> getAllNewsItemTags () async {

  // RESPONSE
  try {

    final response = await http.get(
      Uri.http(domain, '$path/news_item/get_all_news_item_tags.php'),
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
      throw Exception('Failed to load news item tags');
    }
    
  }

  catch (e) {
    return [];
  }

}