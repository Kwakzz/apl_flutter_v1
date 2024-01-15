import 'package:apl/pages/nav_tabs/admin.dart';
import 'package:apl/requests/seasons/add_season_req.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper/widgets/text.dart';
import '../../helper/functions/convert_to_json.dart';


/// This class is the stateful widget where the player can edit their details
class AddSeason extends StatefulWidget {

  const AddSeason(
    {
      super.key, 
      required this.pageName,
    }
  );

  final String pageName;
  

  @override
  State<AddSeason> createState() => _AddSeasonState();

}

class _AddSeasonState extends State<AddSeason> {

  String pageName = 'Add Season';
  final _formKey = GlobalKey<FormState>();

  // Date of birth
  DateTime? _selectedDate;


  // Controllers for the text fields
  final _seasonNameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // Season's details
  String seasonDetailsJson = '';

  /// This function shows a date picker when the user taps on the start date and end date fields.
  /// It updates these fields with the selected date.
  /// The second argument is the text of the controller that will be updated.
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  /// Dispose of the controllers when the widget is removed from the tree
  void dispose() {
    _seasonNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
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


        // add season form.
        // It contains the following fields:
        // - season name
        // - start date
        // - end date 

        body: Form(
          key: _formKey,
          child: ListView(
            // Children are the form fields
            children: [

              // Season name
              SignUpTextField(
                controller: _seasonNameController,
                labelText: 'Season Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the season name';
                  }
                  return null;
                },
              ),

              // Start date
              SignUpTextField(
                controller: _startDateController,
                labelText: 'Start Date',
                validator: (value) {
                  // Check if start date is empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start date';
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
                onTap: () {
                  _selectDate(context, _startDateController);
                },
              ),

              // End date
              SignUpTextField(
                controller: _endDateController,
                labelText: 'End Date',
                validator: (value) {
                  // Check if end date is empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end date';
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
                onTap: () {
                  _selectDate(context, _endDateController);
                },
              ),



              // Finish button
              SignUpButton(
                text: "Finish",
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {

                    seasonDetailsJson = convertSeasonDetailsToJson(
                    _seasonNameController.text, 
                    _startDateController.text,
                    _endDateController.text
                    );
                

                     Map <String, dynamic> response = await addSeason(seasonDetailsJson);

                    if (!mounted) return;

                    if (response['status']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor:const Color.fromARGB(255, 28, 28, 28),
                          content: AppText(
                            text: response['message'], 
                            fontWeight: FontWeight.w300, 
                            fontSize: 12, 
                            color: Colors.white
                          ),
                          duration:const Duration(seconds: 2),
                        ),
                      );

                      // Navigate to the admin page
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const Admin(
                            pageName: 'Admin',
                          )
                        )
                      );

                    }
                    
                    else {
                      // Display an error message
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return ErrorDialogueBox(
                            content: response['message']
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


