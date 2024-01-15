
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/my_data_table.dart';
import 'package:apl/requests/goal/get_player_total_goals_req.dart';
import 'package:apl/requests/players/get_player_no_of_appearances_req.dart';
import 'package:apl/requests/players/get_player_no_of_losses_req.dart';
import 'package:apl/requests/players/get_player_no_of_wins_req.dart';
import 'package:apl/requests/players/get_player_req.dart';
import 'package:apl/requests/transfers/get_transfers_by_player_req.dart';
import 'package:flutter/material.dart';
import '../helper/widgets/text.dart';


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
  int noOfLosses = 0;
  int noOfDraws = 0;
  int age = 0;


  @override
  /// This function is called when the page loads.
  void initState() {
    super.initState();

    try{
      age = DateTime.now().year - int.parse(widget.playerMap['date_of_birth'].substring(0, 4));
    }
    catch (e) {
      return;
    }


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
          noOfWins = result['no_of_wins'];
        });
      }
      catch(e) {
        return;
      }
    });

    getPlayerNoOfLosses(widget.playerMap['player_id']).then((result) {
      try{
        setState(() {        
          noOfLosses = result['no_of_losses'];
        });
      }
      catch(e) {
        return;
      }
    });

    noOfDraws = noOfAppearances - noOfWins - noOfLosses;
    

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

              // player image
              Container(
                padding: const EdgeInsets.only(left: 80, top: 20),
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 0, 53, 91),
                height: 250,
                child: player['player_image_url'] == null || player['player_image_url'] == '' ? const Icon(Icons.image_not_supported, size: 13): Image.network(
                  player['player_image_url'],
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  scale: 0.5,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.person,
                        size: 150,
                        color: Colors.white,
                      ),
                    );
                  }
                ),
              ),

              const SizedBox(height: 20),


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
                value: player['fname'] == null && player['lname'] == null ? 'N/A' : '${player['fname']} ${player['lname']}',
              ),

              // Player date of birth
              PlayerDetailListTile(
                heading: 'Date of birth',
                value: player['date_of_birth'] == null ? 'N/A' : player['date_of_birth'].toString(),
              ),

              // Player gender
              PlayerDetailListTile(
                heading: 'Gender',
                value: player['gender'] == null ? 'N/A' : player['gender'].toString(),
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
                value: player['team_name'] == null ? 'N/A' : player['team_name'].toString(),
              ),

              // position
              PlayerDetailListTile(
                heading: 'Position',
                value: player['position_name'] == null ? 'N/A' : player['position_name'].toString(),
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
                value: noOfLosses.toString()
              ),

              // draws
              PlayerDetailListTile(
                heading: "Draws",
                value: noOfDraws.toString()
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