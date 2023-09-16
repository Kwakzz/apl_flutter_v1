import 'package:apl/admin.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/requests/gameweeks/add_gw_req.dart';
import '../../helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_functions/convert_to_json.dart';
import 'package:apl/requests/seasons/get_seasons_req.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/signup_field.dart';



class AddGameweek extends StatefulWidget {
  const AddGameweek({super.key});

  @override
  _AddGameweekState createState() => _AddGameweekState();
}

class _AddGameweekState extends State<AddGameweek> {

  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> seasonsMap = [];

  List<Map<String, dynamic>> gameweeks = [];

  // map of selected season
  Map <String, dynamic> selectedSeasonMap = {};

  // gameweek json to be sent to the server
  String gameweekJson = "";

  // text editing controllers for the form fields
  final _gameweekNumberController = TextEditingController();
  final _gameweekDateController = TextEditingController();

  // selected date
  DateTime? _selectedGameweekDate;

  /// This function shows a date picker when the user taps on the date of birth field.
  /// It updates the date of birth field with the selected date.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    

    if (pickedDate != null && pickedDate != _selectedGameweekDate) {
      setState(() {
        _selectedGameweekDate = pickedDate;
        _gameweekDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  /// This function is called when the page loads.
  /// It calls the function to get the fans, teams and positions.
  /// It also sets the filteredCoaches list to the coaches list.
  void initState() {
    super.initState();

    // Call the function to get the seasons when the page loads
    getSeasons().then((result) {
      setState(() {
        seasonsMap = result;
        if (seasonsMap.isNotEmpty) {
          selectedSeasonMap = seasonsMap[0];
        } else {
          selectedSeasonMap = {};
        }
      }
    );
    });
  }


  @override
  Widget build(BuildContext context) {

    // list of season names
    // will be used to display the season names in the dropdown menu
    final seasonNames = seasonsMap.map((season) => season['season_name'] as String).toList();


    // season drop down menu
    // dropdown list for teams
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
    SignUpDropdownFormField seasonsDropDown = SignUpDropdownFormField(
      items: seasonNames,
      labelText: "Season",
      onChanged: (newValue) {
      setState(() {
        selectedSeasonMap = seasonsMap.firstWhere(
          (season) => season["season_name"].toString() == newValue,
          orElse: () => {},
        );
      });
  },
    );


    return Scaffold(

      // app bar with back button and page name 
      appBar: CustomAppbar(
        pageName: "Add Gameweek",
        icon: const Icon(Icons.arrow_back),
        prevContext: context,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          // Children are the form fields
          children: [ 

            // Season drop down menu
            seasonsDropDown,

            // Gameweek number
              SignUpTextField(
                controller: _gameweekNumberController,
                labelText: 'Gameweek Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a gameweek number';
                  }
                  // Check if the gameweek number is a number
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid gameweek number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),

              // Gameweek date
              SignUpTextField(
                controller: _gameweekDateController,
                labelText: 'Gameweek Date',
                validator: (value) {
                  // Check if email is empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter the gameweek date';
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
                onTap: () {
                  _selectDate(context);
                },
              ),

            // Finish button
            SignUpButton(
              text: "Finish",
              onPressed: () async {
                // Validate the form
                if (_formKey.currentState!.validate()) {

                  gameweekJson = createGameweekJson(
                    selectedSeasonMap["season_id"], 
                    _gameweekNumberController.text, 
                    _gameweekDateController.text
                  );

                  Map<String, dynamic> response = await addGameweek(gameweekJson);

                  if (!mounted) return;

                  if (response['status']) {

                    // Show success message
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return ErrorDialogueBox(
                          content: response['message'],
                          text: "Success",
                        );
                      }
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
                      builder: (context) {
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
    );
  }
}