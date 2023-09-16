import 'dart:io';

import 'package:apl/admin.dart';
import 'package:apl/helper_classes/multi_line_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/text.dart';
import '../../helper_functions/convert_to_json.dart';
import '../../helper_functions/file_upload.dart';
import '../../requests/news_item/edit_news_item_req.dart';


class EditNewsItem extends StatefulWidget {

  const EditNewsItem(
    {
      super.key, 
      required this.pageName,
      required this.newsItem
    }
  );

  final String pageName;
  
  // map of the new item's details
  final Map<String, dynamic> newsItem;
  

  @override
  State<EditNewsItem> createState() => _EditNewsItemState();

}

class _EditNewsItemState extends State<EditNewsItem> {

  String pageName = 'Edit News Item';
  final _formKey = GlobalKey<FormState>();


  // Controllers for the text fields
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _contentController;


  // News item's details
  String newsItemJson = '';


  @override
  /// Dispose of the controllers when the widget is removed from the tree
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.newsItem['title']);
    _subtitleController = TextEditingController(text: widget.newsItem['subtitle']);
    _contentController = TextEditingController(text: widget.newsItem['content']);
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
              


              MultiLineTextField(
                controller: _titleController,
                labelText: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),

              MultiLineTextField(
                controller: _subtitleController,
                labelText: 'Subtitle',
              ),

              // Team name abbrev
              MultiLineTextField(
                controller: _contentController,
                labelText: 'Content',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the content";
                  }
                  return null;
                },
              ),            


              // Continue button
              SignUpButton(
                text: "Finish",
                onPressed: () async {

                  // image url
                  String imageUrl = widget.newsItem['cover_pic'];

                  // Validate the form
                  if (_formKey.currentState!.validate()) {

                    if (_image != null) {

                      String url = "http://localhost/backend/api/news_item/add_cover_pic.php";

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

                    newsItemJson = createNewsItemJson(
                      widget.newsItem['news_item_id'],
                      _titleController.text, 
                      _subtitleController.text,
                      _contentController.text,
                      imageUrl,
                    );
                

                    Map <String, dynamic> response = await editNewsItem(newsItemJson);

                    if (!mounted) return;

                    if (response['status']) {
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color.fromARGB(255, 28, 28, 28),
                          content: AppText(
                            text: 'News item edited successfully', 
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


