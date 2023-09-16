import 'package:apl/helper_classes/custom_dialog_box.dart';
import 'package:apl/helper_classes/custom_dropdown.dart';
import 'package:apl/requests/standings/add_standings_req.dart';
import 'package:flutter/material.dart';
import '../../helper_classes/custom_button.dart';
import '../../helper_classes/signup_field.dart';
import '../../helper_functions/convert_to_json.dart';


/// This class is the stateful widget where the player can edit their details
class AddStandingsForm extends StatefulWidget {

  const AddStandingsForm(
    {
      super.key, 
      required this.compsMap,
      required this.seasonsMap
    }
  );


  // for the men's tab, it's only men's competitions
  // for the women's tab, it's only women's competitions 
  final List<Map<String, dynamic>>compsMap;

  final List<Map<String, dynamic>>seasonsMap;


  @override
  State<AddStandingsForm> createState() => _AddStandingsFormState();

}

class _AddStandingsFormState extends State<AddStandingsForm> {

  String pageName = 'Add Table';
  final _formKey = GlobalKey<FormState>();

  // standings json
  String standingsJson = '';

  // selected season map
  Map<String, dynamic> _selectedSeasonMap = {};

  // selected competition map
  Map<String, dynamic> _selectedCompMap = {};

  // standings name controller
  final _standingsNameController = TextEditingController();


  
  @override
  Widget build (BuildContext context) {


    final compNames = widget.compsMap.map((comp) => comp['competition_name']).toList();

    final seasonNames = widget.seasonsMap.map((season) => season['season_name']).toList();

    // season dropdown
    final SignUpDropdownFormField seasonNamesDropDown = SignUpDropdownFormField(
      items: seasonNames,
      labelText: "Season",
      onChanged: (newValue) {
        setState(() {

          _selectedSeasonMap = widget.seasonsMap.firstWhere(
            (season) => season["season_name"] == newValue,
            orElse: () => {},
          );
        }
        );
      },
      validator: (value) {
        // Check if season competition is empty
        if (value == null || value.isEmpty) {
          return 'Please enter a season';
        }
        return null;
      },
    );

    SignUpDropdownFormField compNamesDropDown = SignUpDropdownFormField(
      items: compNames,
      labelText: "Competition",
      onChanged: (newValue) {
        setState(() {

          _selectedCompMap = widget.compsMap.firstWhere(
            (comp) => comp["competition_name"] == newValue,
            orElse: () => {},
          );
        }
        );
      },
      validator: (value) {
        // Check if season competition is empty
        if (value == null || value.isEmpty) {
          return 'Please enter a competition';
        }
        return null;
      },
    );

   
    return Form(
      key: _formKey,
      child: ListView(
        // Children are the form fields
        children: [

          // Standings name
          SignUpTextField(
            controller: _standingsNameController,
            labelText: "Standings Name",
            validator: (value) {
              // Check if standings name is empty
              if (value == null || value.isEmpty) {
                return 'Please enter a name for the standings';
              }
              return null;
            },
          ),

          seasonNamesDropDown,

          compNamesDropDown,
    

          // Finish button
          SignUpButton(
            text: "Finish",
            onPressed: () async {
              // Validate the form
              if (_formKey.currentState!.validate()) {   

                // convert standings details to json
                standingsJson = createStandingsJson(
                  _standingsNameController.text,
                  _selectedCompMap['competition_id'].toString
                  (),
                  _selectedSeasonMap['season_id'].toString(),           
                );

                // send request to add standings
                Map<String, dynamic> response = await addStandings(standingsJson);

                if (!mounted) return;

                if (response['status']) {
                   showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return ErrorDialogueBox(
                        content: response['message'],
                        text: "Success",
                      );
                    }
                  );
                  // Navigate to previous screen
                  Navigator.pop(context);
                }
                else {
                  // show error message
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
    );
  }
}


