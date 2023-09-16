import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to delete a transfer.
Future <Map<String, dynamic>> deleteTransfer (String transferDetails) async {

  Map<String, dynamic> result = {};

  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/transfer/delete.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: transferDetails
    );
 
    if (response.statusCode == 204) {
      result = {
        'status': true,
        'message': "Transfer deleted successfully"
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Error deleting transfer"
      };
      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Error deleting transfer"
    };
    return result;
  }

}
