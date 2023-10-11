import 'package:apl/helper_classes/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class topScorersTable extends StatelessWidget {

  const topScorersTable(
    {
      super.key,
      required this.topScorers,
    }
  );

  final List<Map<String, dynamic>> topScorers;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[

        // pos
        DataColumn(
          label: AppText(
            text: 'POS',
            color: Color.fromARGB(255, 53, 52, 52),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        // name
        DataColumn(
          label: AppText(
            text: 'NAME',
            color: Color.fromARGB(255, 53, 52, 52),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        // team
        DataColumn(
          label: AppText(
            text: 'TEAM',
            color: Color.fromARGB(255, 53, 52, 52),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

            // goals      
        DataColumn(
          label: AppText(
            text: 'GOALS',
            color: Color.fromARGB(255, 53, 52, 52),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],

      rows: topScorers.map((topScorer) => DataRow(
          cells: [

            // pos
            DataCell(
              AppText(
                // index + 1 because index starts at 0
                text: (topScorers.indexOf(topScorer) + 1).toString(),
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            // name
            DataCell(
              AppText(
                // pick only the first of the player's first names
                text:'${topScorer['fname'].toString().split(' ')[0]} ${topScorer['lname']}',
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),

            // team
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    topScorer['team_logo_url'],
                    width: 20,
                    height: 20,
                  ),
                  AppText(
                    text: topScorer['team_name_abbrev'].toString(),
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ]
              )
            ),

            // goals
            DataCell(
              AppText(
                text: topScorer['no_of_goals'].toString(),
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ).toList(),
    );
  }
  
}

class topAssistProvidersTable extends StatelessWidget {

  const topAssistProvidersTable(
    {
      super.key,
      required this.topAssistProviders,
    }
  );

  final List<Map<String, dynamic>> topAssistProviders;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[

        // pos
        DataColumn(
          label: AppText(
            text: 'POS',
            color: Color.fromARGB(255, 53, 52, 52),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        // name
        DataColumn(
          label: AppText(
            text: 'NAME',
            color: Color.fromARGB(255, 53, 52, 52),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        // team
        DataColumn(
          label: AppText(
            text: 'TEAM',
            color: Color.fromARGB(255, 53, 52, 52),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

            // assists      
        DataColumn(
          label: AppText(
            text: 'ASSISTS',
            color: Color.fromARGB(255, 53, 52, 52),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],

      rows: topAssistProviders.map((topAssistProvider) => DataRow(
          cells: [

            // pos
            DataCell(
              AppText(
                // index + 1 because index starts at 0
                text: (topAssistProviders.indexOf(topAssistProvider) + 1).toString(),
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            // name
            DataCell(
              AppText(
                text:'${topAssistProvider['fname'].toString().split(' ')[0]} ${topAssistProvider['lname']}',
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),

            // team
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    topAssistProvider['team_logo_url'],
                    width: 20,
                    height: 20,
                  ),
                  AppText(
                    text: topAssistProvider['team_name_abbrev'].toString(),
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ]
              )
            ),

            // assists
            DataCell(
              AppText(
                text: topAssistProvider['no_of_assists'].toString(),
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ).toList(),
    );
  }
  
}

class TopCleanSheetsTable extends StatelessWidget {

  const TopCleanSheetsTable(
    {
      super.key,
      required this.topCleanSheets,
    }
  );

  final List<Map<String, dynamic>> topCleanSheets;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: DataTable(
          columns: const <DataColumn>[

            // pos
            DataColumn(
              label: AppText(
                text: 'Pos',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),

            // name
            DataColumn(
              label: AppText(
                text: 'Club',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          
            // clean sheets      
            DataColumn(
              label: AppText(
                text: 'CS',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

          ],

          rows: topCleanSheets.map((teamWithCleanSheet) => DataRow(
              cells: [

                // pos
                DataCell(
                  AppText(
                    // index + 1 because index starts at 0
                    text: (topCleanSheets.indexOf(teamWithCleanSheet) + 1).toString(),
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // name
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    
                    children: [
                      Image.network(
                        '${teamWithCleanSheet['team_logo_url']}',
                        height: 20,
                        width: 20,
                      ),
                      const Text("  "),
                      AppText(
                        text:'${teamWithCleanSheet['team_name_abbrev']}',
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ]

                  )
                ),

                // clean sheets
                DataCell(
                  AppText(
                    text:'${teamWithCleanSheet['no_of_clean_sheets']}',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            )
          ).toList(),
        )
      )
    );
  }
  
}


class LeagueTable extends StatelessWidget {

  const LeagueTable(
    {
      super.key,
      required this.standingsTeams,
    }
  );

  final List<Map<String, dynamic>> standingsTeams;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[

          // pos
          DataColumn(
            label: AppText(
              text: 'Pos',
              color: Color.fromARGB(255, 53, 52, 52),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          // name
          DataColumn(
            label: AppText(
              text: 'Club',
              color: Color.fromARGB(255, 53, 52, 52),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          // played
          DataColumn(
            label: AppText(
              text: 'PL',
              color: Color.fromARGB(255, 53, 52, 52),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          // wins
          DataColumn(
            label: AppText(
              text: 'W',
              color: Color.fromARGB(255, 53, 52, 52),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          // draws      
          DataColumn(
            label: AppText(
              text: 'D',
              color: Color.fromARGB(255, 53, 52, 52),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          // losses      
          DataColumn(
            label: AppText(
              text: 'L',
              color: Color.fromARGB(255, 53, 52, 52),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          // goal difference      
          DataColumn(
            label: AppText(
              text: 'GD',
              color: Color.fromARGB(255, 53, 52, 52),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          // points      
          DataColumn(
            label: AppText(
              text: 'PTS',
              color: Color.fromARGB(255, 53, 52, 52),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],

        rows: standingsTeams.map((standingsTeam) => DataRow(
            cells: [

              // pos
              DataCell(
                AppText(
                  // index + 1 because index starts at 0
                  text: (standingsTeams.indexOf(standingsTeam) + 1).toString(),
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // name
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  children: [
                    Image.network(
                      '${standingsTeam['team_logo_url']}',
                      height: 20,
                      width: 20,
                    ),
                    const Text("  "),
                    AppText(
                      text:'${standingsTeam['team_name_abbrev']}',
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ]

                )
              ),

              // no_played
              DataCell(
                AppText(
                  text:'${standingsTeam['no_played']}',
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),


              // goals
              DataCell(
                AppText(
                  text: standingsTeam['wins'].toString(),
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              DataCell(
                AppText(
                  text: standingsTeam['draws'].toString(),
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              DataCell(
                AppText(
                  text: standingsTeam['losses'].toString(),
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              DataCell(
                AppText(
                  text: standingsTeam['goal_difference'].toString(),
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              DataCell(
                AppText(
                  text: standingsTeam['points'].toString(),
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ).toList(),
      )
    );
  }
  
}



class LatestLeagueTable extends StatelessWidget {

  const LatestLeagueTable(
    {
      super.key,
      required this.standingsTeams,
    }
  );

  final List<Map<String, dynamic>> standingsTeams;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        )
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: MediaQuery.of(context).size.width * 0.0418,
          columns: const <DataColumn>[

            // pos
            DataColumn(
              label: AppText(
                text: 'Pos',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),

            // name
            DataColumn(
              label: AppText(
                text: 'Club',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),

            // played
            DataColumn(
              label: AppText(
                text: 'PL',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),

            // wins
            DataColumn(
              label: AppText(
                text: 'W',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

            // draws      
            DataColumn(
              label: AppText(
                text: 'D',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

            // losses      
            DataColumn(
              label: AppText(
                text: 'L',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

            // goals scored
            DataColumn(
              label: AppText(
                text: 'GS',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

            // goal difference      
            DataColumn(
              label: AppText(
                text: 'GD',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

            // points      
            DataColumn(
              label: AppText(
                text: 'PTS',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          rows: standingsTeams.map((standingsTeam) => DataRow(
              cells: [

                // pos
                DataCell(
                  AppText(
                    // index + 1 because index starts at 0
                    text: (standingsTeams.indexOf(standingsTeam) + 1).toString(),
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // name
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    
                    children: [
                      Image.network(
                        '${standingsTeam['team_logo_url']}',
                        height: 20,
                        width: 20,
                      ),
                      const Text("  "),
                      AppText(
                        text:'${standingsTeam['team_name_abbrev']}',
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ]

                  )
                ),

                // no_played
                DataCell(
                  AppText(
                    text:'${standingsTeam['no_played']}',
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),


                // goals
                DataCell(
                  AppText(
                    text: standingsTeam['wins'].toString(),
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                DataCell(
                  AppText(
                    text: standingsTeam['draws'].toString(),
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                DataCell(
                  AppText(
                    text: standingsTeam['losses'].toString(),
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                DataCell(
                  AppText(
                    text: standingsTeam['goals_scored'].toString(),
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                DataCell(
                  AppText(
                    text: standingsTeam['goal_difference'].toString(),
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                DataCell(
                  AppText(
                    text: standingsTeam['points'].toString(),
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ).toList(),
        )
      )
    );
  }
  
}


class PlayerTransfersTable extends StatelessWidget {

  const PlayerTransfersTable(
    {
      super.key,
      required this.playerTransfers,
    }
  );

  final List<Map<String, dynamic>> playerTransfers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        child: DataTable(
          columnSpacing: MediaQuery.of(context).size.width * 0.04,
          columns: const <DataColumn>[

            // transfer type
            DataColumn(
              label: AppText(
                text: 'Transfer Type',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          
            // previous club      
            DataColumn(
              label: AppText(
                text: 'Prev Club',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

            // new club
            DataColumn(
              label: AppText(
                text: 'New Club',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

            // transfer date
            DataColumn(
              label: AppText(
                text: 'Transfer Date',
                color: Color.fromARGB(255, 53, 52, 52),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

          ],

          rows: playerTransfers.map((transfer) => DataRow(
              cells: [

                // transfer type
                DataCell(
                  AppText(
                    text: transfer['transfer_type'],
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                // prev club
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    
                    children: [
                      Image.network(
                        '${transfer['prev_team_logo_url']}',
                        height: 20,
                        width: 20,
                      ),
                      const Text("  "),
                      AppText(
                        text:'${transfer['prev_team_name_abbrev']}',
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ]

                  )
                ),

                // new club
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    
                    children: [
                      Image.network(
                        '${transfer['new_team_logo_url']}',
                        height: 20,
                        width: 20,
                      ),
                      const Text("  "),
                      AppText(
                        text:'${transfer['new_team_name_abbrev']}',
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ]
                  )
                ),

                // transfer date
                DataCell(
                  AppText(
                    text: DateFormat('MMMM y').format(DateTime.parse(transfer['transfer_date'])),
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),

             
              ],
            )
          ).toList(),
        )
      )
    );
  }
  
}
