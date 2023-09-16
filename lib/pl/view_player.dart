
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/my_data_table.dart';
import 'package:apl/requests/goal/get_player_total_goals_req.dart';
import 'package:apl/requests/players/get_player_no_of_appearances_req.dart';
import 'package:apl/requests/players/get_player_no_of_wins_req.dart';
import 'package:apl/requests/players/get_player_req.dart';
import 'package:apl/requests/transfers/get_transfers_by_player_req.dart';
import 'package:flutter/material.dart';
import '../helper_classes/text.dart';


class ViewPlayer extends StatefulWidget {
  
  const ViewPlayer(
    {
      super.key,
      required this.playerMap
    }
  );

  final Map<String, dynamic> playerMap;

  @override
  _ViewPlayerState createState() => _ViewPlayerState();
}

class _ViewPlayerState extends State<ViewPlayer> {

  Map<String, dynamic> player = {};

  List <Map<String, dynamic>> transfers = [];

  int noOfGoals = 0;
  int noOfAppearances = 0;
  int noOfWins = 0;
  int age = 0;


  @override
  /// This function is called when the page loads.
  void initState() {
    super.initState();


    age = DateTime.now().year - int.parse(widget.playerMap['date_of_birth'].substring(0, 4));


    getPlayerTotalGoals(widget.playerMap['player_id']).then((result) {

      try{
        setState(() {        
          noOfGoals = result['total_goals'];
        });
      }
      catch(e) {
        return;
      }
    });

    getPlayerNoOfAppearances(widget.playerMap['player_id']).then((result) {

      try{
        setState(() {        
          noOfAppearances = result['no_of_games_played'];
        });
      }
      catch(e) {
        return;
      }
    });

    getPlayerNoOfWins(widget.playerMap['player_id']).then((result) {
      try{
        setState(() {        
          noOfWins = result['total_wins'];
        });
      }
      catch(e) {
        return;
      }
    });

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppbar(
        pageName: '${widget.playerMap['fname']} ${widget.playerMap['lname']}',
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        prevContext: context,
      ),

      body: FutureBuilder(
      
        future: Future.wait(
          [
            getPlayerById(widget.playerMap['player_id']),
            getTransfersByPlayer(widget.playerMap['player_id']),
          ]
        ),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: AppText(
                text: "Error loading data",
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              )
            );
          }

          final List<dynamic> data = snapshot.data as List<dynamic>;
          player = data[0];
          transfers = data[1];

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

              // height
              PlayerDetailListTile(
                heading: 'Height',
                value: player['height'] == null ? 'N/A' : player['height'].toString(),
              ),

              // year group
              PlayerDetailListTile(
                heading: 'Year Group',
                value: player['year_group'] == null ? 'N/A' : player['year_group'].toString(),           
              ),

              // club
              PlayerDetailListTile(
                heading: 'Club',
                value: player['club_name'] == null ? 'N/A' : player['club_name'].toString(),
              ),

              // position
              PlayerDetailListTile(
                heading: 'Position',
                value: player['position'] == null ? 'N/A' : player['position'].toString(),
              ),


              // APL record
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const AppText(
                  text: 'APL Record',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              ),

              const SizedBox(height: 20),

              // appearances
              PlayerDetailListTile(
                heading: "Appearances", 
                value: noOfAppearances.toString()
              ),

              // goals
              PlayerDetailListTile(
                heading: "Goals",
                value: noOfGoals.toString()
              ),

              // wins
              PlayerDetailListTile(
                heading: "Wins",
                value: noOfWins.toString()
              ),

              // losses
              PlayerDetailListTile(
                heading: "Losses",
                value: "0"
              ),

              // transfer history
              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const AppText(
                  text: 'Transfer History',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              ),

              // if transfers is empty, don't show the table
              if (transfers.isNotEmpty)
                PlayerTransfersTable(playerTransfers: transfers),



            ],
          );

        }
      )
      
    
    );
        
   
  }

}