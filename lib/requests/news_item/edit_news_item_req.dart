import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to edit a news item.
Future <Map<String, dynamic>> editNewsItem (String newsItemDetails) async {

  Map <String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/news_item/edit.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: newsItemDetails
    );
 
    if (response.statusCode == 200) {
      result = {
        'success': true,
        'message': "News item edited successfully"
      };
      return result;
    }

    else {
      result = {
        'success': false,
        'message': "Error editing news item"
      };
      return result;
    }
    
  }

  catch (e) {
    result = {
      'success': false,
      'message': "Error editing news item"
    };
    return result;
  }

}
