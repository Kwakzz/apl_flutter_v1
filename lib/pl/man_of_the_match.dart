import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/man_of_the_match/get_motm_req.dart';
import 'package:flutter/material.dart';


class ManOfTheMatch extends StatefulWidget {
  const ManOfTheMatch(
    {
      super.key,
      required this.game,
      required this.homeTeam,
      required this.awayTeam,
    }
  );

  final Map<String, dynamic> game;
  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;

  @override
  _ManOfTheMatchState createState() => _ManOfTheMatchState();
}

class _ManOfTheMatchState extends State<ManOfTheMatch> {

  Map <String, dynamic> motm = {};

  List<Map<String, dynamic>> homeTeamPlayers = [];
  List<Map<String, dynamic>> awayTeamPlayers = [];

  List<Map<String, dynamic>> playersDropDownMap = [];
  List<String> playersDropDownList = [];


  

  @override
  void initState() {
    super.initState();

    getMOTM(widget.game['game_id']).then((result) {
      setState(() {
        motm = result;

      });
    });

  }

  @override
  Widget build(BuildContext context) {


    return ListView(

        children: [

          if (motm.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 20, top: 20),
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 0, 53, 91),
              height: 170,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "${motm['fname']} ${motm['lname']}",
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          AppText(
                            text: motm['position_name'],
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Expanded(
                        child: motm['player_image_url'] == null || motm['player_image_url'] == '' ? const Icon(Icons.image_not_supported, size: 13): Image.network(
                          motm['player_image_url'],
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
                    ],
                  ),
                ],
              ),
            )

          else

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText (
                text: "Man of the Match not announced yet",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )
            )
          )
          
                
        ]
      );


  }
    
}
