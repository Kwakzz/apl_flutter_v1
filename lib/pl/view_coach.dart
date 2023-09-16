
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/requests/coach/get_coach_req.dart';
import 'package:apl/requests/goal/get_player_total_goals_req.dart';
import 'package:apl/requests/players/get_player_req.dart';
import 'package:apl/requests/transfers/get_transfers_by_player_req.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../helper_classes/text.dart';


class ViewCoach extends StatefulWidget {
  
  const ViewCoach(
    {
      super.key,
      required this.coachMap
    }
  );

  final Map<String, dynamic> coachMap;

  @override
  _ViewCoachState createState() => _ViewCoachState();
}

class _ViewCoachState extends State<ViewCoach> {

  Map<String, dynamic> player = {};

  List transfers = [];

  int noOfGoals = 0;
  int age = 0;


  @override
  /// This function is called when the page loads.
  void initState() {
    super.initState();


    getCoach(widget.coachMap['coach_id']).then((result) {
      setState(() {
        player = result;
      });
    });

    age = DateTime.now().year - int.parse(widget.coachMap['date_of_birth'].substring(0, 4));

  }

  

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppbar(
        pageName: '${widget.coachMap['fname']} ${widget.coachMap['lname']}',
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        prevContext: context,
      ),

      body: FutureBuilder(
      
        future: getCoach(widget.coachMap['coach_id']),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(

            children: [

              const SizedBox(height: 20),

              // Player image
              // Container(
              //   margin: const EdgeInsets.only(left: 20),
              //   child: CircleAvatar(
              //     radius: 50,
              //     backgroundImage: NetworkImage(widget.playerMap['image_url']),
              //   ),
              // ),

              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const AppText(
                  text: 'Personal details',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              ),

              const SizedBox(height: 20),

              // Player name
              PlayerDetailListTile(
                heading: 'Full Name',
                value: '${player['fname']} ${player['lname']}',
              ),

              // Player date of birth
              PlayerDetailListTile(
                heading: 'Date of birth',
                value: player['date_of_birth'],
              ),

              // Player gender
              PlayerDetailListTile(
                heading: 'Gender',
                value: player['gender'],
              ),

              // age
              PlayerDetailListTile(
                heading: 'Age',
                value: age.toString(),
              ),

              // year group
              PlayerDetailListTile(
                heading: 'Year Group',
                value: player['year_group'].toString(),
              ),

              // club
              PlayerDetailListTile(
                heading: 'Club',
                value: player['team_name'],
              ),

            ],
          );

        }
      )
      
    
    );
        
   
  }

}