import 'dart:io';
import 'package:apl/admin.dart';
import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/multi_line_text_field.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rich_field_controller/rich_field_controller.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper_functions/convert_to_json.dart';
import '../../helper_functions/file_upload.dart';
import '../../requests/news_item/add_news_item_req.dart';


/// This class is the stateful widget for adding a news item
class AddNewsItem extends StatefulWidget {

  const AddNewsItem(
    {
      super.key, 
      required this.pageName,
    }
  );

  final String pageName;
  

  @override
  State<AddNewsItem> createState() => _AddNewsItemState();

}

class _AddNewsItemState extends State<AddNewsItem> {

  String pageName = 'Add News Item';
  final _formKey = GlobalKey<FormState>();


  // Controllers for the text fields
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  late final RichFieldController _contentController;
  late final FocusNode _fieldFocusNode;
  late final RichFieldSelectionControls _selectionControls;


  // Team's details
  String newsItemJson = '';

  @override
  void initState() {
    super.initState();
    _fieldFocusNode = FocusNode();
    _contentController = RichFieldController(focusNode: _fieldFocusNode);
    _selectionControls = RichFieldSelectionControls(context, _contentController);
  }


  @override
  /// Dispose of the controllers when the widget is removed from the tree
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }

  final ImagePicker picker = ImagePicker();


  File? _image;

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

   /// Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const AppText(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w300,
              text: "From Gallery",
            ),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const AppText(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w300,
              text: "Camera",
            ),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build (BuildContext context) {

    
   
    return MaterialApp(
      home: Scaffold (

        // app bar with back button and page name 
        appBar: CustomAppbar(
          pageName: pageName,
          icon: const Icon(Icons.arrow_back),
          prevContext: context,
        ),

        body: Form(
          key: _formKey,
          child: ListView(
            // Children are the form fields
            children: [

              // QuillToolbar.basic(controller: _contentController),

              UploadImageButton(
                onPressed: () {
                  showOptions();
                },
              ),

              Center(
                child: _image == null ?const AppText(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  text: "No cover image selected",
                ) : Image.file(_image!),
              ),
              

              // Title
              MultiLineTextField(
                controller: _titleController, 
                labelText: "Title",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              // Subtitle
              MultiLineTextField(
                controller: _subtitleController, 
                labelText: "Subtitle",
              ),

              // Content
              RichTextField(
                controller: _contentController, 
                selectionControls: _selectionControls,
                labelText: "Content",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the content';
                  }
                  return null;
                },
              ),

      

              // Continue button
              SignUpButton(
                text: "Finish",
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {

                    // image url
                    String imageUrl = '';
                    
                    if (_image != null) {

                      String url = "http://3.8.171.188/backend/api/news_item/add_cover_pic.php";

                      Map<String, dynamic> imageUpload = await uploadImage(_image!, url);

                      if (!mounted) return;

                      if (imageUpload['status']) {

                        imageUrl = imageUpload['cloudinary_url']; 
                        
                      }

                      else {
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return ErrorDialogueBox(
                              content: imageUpload['message'],
                            );
                          }
                        );
                      }

                    }

                    // String content = jsonEncode(_contentController.document.toDelta().toJson());

                    newsItemJson = createNewsItemJson(
                      _titleController.text, 
                      _subtitleController.text,
                      _contentController.text, 
                      DateTime.now().toString(),
                      imageUrl,
                    );

                    Map<String, dynamic> response = await addNewsItem(newsItemJson);

                    if (!mounted) return;

                    if (response['status']) {

                      // Show success message
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color.fromARGB(255, 28, 28, 28),
                          content: AppText(
                            text: 'News item added successfully', 
                            fontWeight: FontWeight.w300, 
                            fontSize: 12, 
                            color: Colors.white
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Navigate to the next screen
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const Admin(
                            pageName: 'Admin',
                          ),
                        ),                 
                      );

                    }

                    else {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return ErrorDialogueBox(
                            content: response['message'],
                          );
                        }
                      );
                    }
                   
                  }
                },
              )
              
              
            ],
          ) 
        ),

        backgroundColor: const Color.fromARGB(255, 0, 53, 91),
      )
    );
  }
}


