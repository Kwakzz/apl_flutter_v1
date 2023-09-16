import 'package:apl/admin.dart';
import 'package:apl/helper_classes/radio_form_field.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/requests/competitions/get_distinct_comps_req.dart';
import 'package:apl/requests/seasons/add_season_comp_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/custom_appbar.dart';
import '../../helper_classes/custom_dialog_box.dart';
import '../../helper_classes/text.dart';
import '../../helper_functions/convert_to_json.dart';


/// This class is the stateful widget where the player can edit their details
class AddSeasonComp extends StatefulWidget {

  const AddSeasonComp(
    {
      super.key, 
      required this.pageName,
      required this.seasonId
    }
  );

  final String pageName;
  final int seasonId;
  

  @override
  State<AddSeasonComp> createState() => _AddSeasonCompState();

}

class _AddSeasonCompState extends State<AddSeasonComp> {

  String pageName = 'Add Season Competition';
  final _formKey = GlobalKey<FormState>();


  // Values for form
  String _selectedCompetition = '';
  String _selectedGender = "Male";

  // List of competition names for drop down list
  List<String> compNames = [];

  // Json for season competition details
  String seasonCompDetailsJson = '';

   @override
  void initState() {
    super.initState();

    // get the teams for drop down list
    getDistinctCompNames().then((value) {
      setState(() {
        compNames = value;
      });
    });

  }

  
  @override
  Widget build (BuildContext context) {

    // dropdown list for teams
    // assigned to variable so that it can be used in the form
    // and so that the selected value can be changed
    SignUpDropdownFormField compNamesDropDown = SignUpDropdownFormField(
      items: compNames,
      labelText: "Competition",
      onChanged: (newValue) {
        setState(() {
          _selectedCompetition = newValue!;
        }
        );
      }
    );
    
   
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
        // - competition name
        // - gender

        body: Form(
          key: _formKey,
          child: ListView(
            // Children are the form fields
            children: [

              // competition names dropdown list
              compNamesDropDown,

              // Gender
              RadioFormField(
                labelText: "Gender", 
                firstValue: "Male", 
                secondValue: "Female", 
                selectedValue: _selectedGender, 
                onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              }
                              );
                            },
              ),

              // Finish button
              SignUpButton(
                text: "Finish",
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {

                    seasonCompDetailsJson = seasonCompJson(
                      0,
                      _selectedCompetition,
                      widget.seasonId,
                       _selectedGender,
                    );

                    Map <String, dynamic> response = await addSeasonComp(seasonCompDetailsJson);

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


