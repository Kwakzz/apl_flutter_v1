import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to add a news item.
Future <Map<String, dynamic>> addNewsItem (String newsItemDetails) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/news_item/add.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: newsItemDetails
    );
 
    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': 'News item added successfully'
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': 'News item not added'
      };
      return result;
    }
    
  }

  catch (e) {
      
      result = {
        'status': false,
        'message': 'News item not added'
      };
  
      return result;
      
  }

}
