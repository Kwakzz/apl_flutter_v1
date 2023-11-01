import 'package:apl/admin_pages/seasons/add_season_comp.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/helper_functions/convert_to_json.dart';
import 'package:apl/requests/seasons/delete_season_comp_req.dart';
import 'package:flutter/material.dart';

import '../../helper_classes/custom_dialog_box.dart';


class SeasonCompsView extends StatefulWidget {

  const SeasonCompsView(
    {
      super.key, 
      required this.comps,
      required this.seasonId,
    }
  );

  // This is the list of maps of every men's competition happening in the season
  // It's passed from the season_competitions page
  // It is obtained when the season_competitions page is loaded
  final List<Map<String, dynamic>> comps;

  // The id of the season
  final int seasonId;
  

  @override
  State<SeasonCompsView> createState() => _SeasonCompsViewState();

}

class _SeasonCompsViewState extends State<SeasonCompsView> {

  @override
  Widget build(BuildContext context) {

    // if the list of season competitions is empty, return "No competitions found"
    if (widget.comps.isEmpty) {
      return  Column(

        children: [
          SmallAddButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSeasonComp(
                      pageName: "Add Season Competition",
                      seasonId: widget.seasonId,
                    ),
                  ),
                );
            },
            text: "Add Competition"
          ),

          const Center(
            child: AppText(
            text: 'No competitions found',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            )
          ),

        ],
    
      );
    }

    return Column(
      children: [
                  
        SmallAddButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSeasonComp(
                  seasonId: widget.seasonId,
                  pageName: "Add Season Competition",
                )
              )
            );
          },
          text: "Add Competition"
        ),

        // List of competitions being played in the season
        Expanded(
          child: ListView.builder(
            itemCount: widget.comps.length,
            itemBuilder: (context, index) {
              // Get the details of the competition
              final comp = widget.comps[index];

              return AdminListTile(
                title: '${comp['competition_name']}',
                subtitle: '',
                editOnTap: () {},       
                deleteOnTap: () {
                   String seasonAndCompId = seasonCompJson(
                    comp["competition_id"], 
                    comp["competition_name"],
                    widget.seasonId, 
                    comp["gender"]  
                  );
                  showDialog(
                      context: context, 
                      builder: (context) {
                        return DeleteConfirmationDialogBox(
                          title: "Delete Season Competition", 
                          content: "Are you sure you want to delete this season competition?",
                          onPressed: () async {
                            Map<String, dynamic> response = await deleteSeasonComp(seasonAndCompId);  

                            if (!mounted) return;

                            if (response['status']) {
                              setState(() {
                                widget.comps.removeAt(index);
                              });

                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return ErrorDialogueBox(
                                    text: "Success",
                                    content: response['message'],
                                  );
                                }
                              );
                            }

                            else {
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return ErrorDialogueBox(
                                    text: "Error",
                                    content: response['message'],
                                  );
                                }
                              );
                            }
                          },
                        );
                      }
                    );             
                },
              );
            },
          )
        ),
      ]
    );

  }

}