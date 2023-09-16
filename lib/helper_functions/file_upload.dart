import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';



/// This function sends a POST request to the server to upload an image to cloudinary and return the secure URL.
Future<Map<String, dynamic>> uploadImage(File image, String url) async {
  Map<String, dynamic> responseMap = {};

  try {

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    final uniqueId = const Uuid().v4(); 
    final filename = '$uniqueId.jpg'; 


    request.files.add(http.MultipartFile(
      'file',
      image.readAsBytes().asStream(),
      image.lengthSync(),
      filename: filename
    ));

    var response = await request.send();

    

    if (response.statusCode == 200) {

      responseMap['status'] = true;
      responseMap['message'] = 'Image uploaded successfully';

      // Convert response stream to a string
      final responseString = await response.stream.bytesToString();

      // Parse the JSON response
      final jsonResponse = json.decode(responseString);

      // Assuming the Cloudinary URL is stored in the 'url' field of the JSON response
      final cloudinaryUrl = jsonResponse['cloudinary_url'];

      responseMap['cloudinary_url'] = cloudinaryUrl;

      return responseMap;

    } 
    
    else {

      responseMap['status'] = false;
      responseMap['message'] = 'Image upload failed';


      return responseMap;
    }

  }

  catch (e) {
    responseMap['status'] = false;
    responseMap['message'] = 'Image upload failed';

    return responseMap;
  }

}


