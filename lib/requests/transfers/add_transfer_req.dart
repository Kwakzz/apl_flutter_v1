import 'package:http/http.dart' as https;
import '../api_uri.dart';


/// This function sends a POST request to the API to add a new transfer.
Future <Map<String,dynamic>> addTransfer (String transferDetails) async {

  Map<String, dynamic> result;


  // RESPONSE
  try {

    final response = await https.post(
      Uri.http(domain, '$path/transfer/add.php'),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: transferDetails
    );
 
    if (response.statusCode == 201) {
      result = {
        'status': true,
        'message': "Transfer completed successfully"
      };
      return result;
    }

    else {
      result = {
        'status': false,
        'message': "Failed to complete transfer"
      };
      return result;
    }
    
  }

  catch (e) {
    result = {
      'status': false,
      'message': "Failed to add transfer"
    };
    return result;
  }

}
