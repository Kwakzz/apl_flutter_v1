import 'package:apl/helper/widgets/text.dart';
import 'package:flutter/material.dart';

class TeamSelectionGrid extends StatefulWidget {
  final List<Map<String, dynamic>> teams;
  Map<String, dynamic> selectedTeam;
  final Function(Map<String, dynamic>) onTeamSelected;

  TeamSelectionGrid({
    required this.teams,
    required this.selectedTeam,
    required this.onTeamSelected,
  });

  @override
  _TeamSelectionGridState createState() => _TeamSelectionGridState();
}

class _TeamSelectionGridState extends State<TeamSelectionGrid> {
  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      height: 220,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.25,
      ),
      itemCount: widget.teams.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onTeamSelected(widget.teams[index]);
          },
          child: Container(
            height: 300,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: widget.selectedTeam['team_id'] == widget.teams[index]['team_id'] ? const Color.fromARGB(255, 160, 213, 250): Colors.white,
              border: Border.all(
                color: widget.selectedTeam['team_id'] == widget.teams[index]['team_id'] ? Colors.grey[300]! : Colors.grey[400]!,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  widget.teams[index]['team_logo_url']!,
                  width: 50,
                  height: 50,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error, 
                      size: 18,
                    );
                  }
                ),
                AppText(
                  text: widget.teams[index]['team_name_abbrev'],
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black
                ),
              ],
            ),
          ),
        );
      },
    )
    );
  }
}
