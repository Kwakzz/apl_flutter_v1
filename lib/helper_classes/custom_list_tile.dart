import 'package:apl/helper_classes/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MenuListTile extends StatelessWidget {

  MenuListTile (
    {
      super.key,
      required this.text,
      this.onTap,
      this.tileColor = Colors.white,
      this.textColor = Colors.black,
    }
  );

  String text;
  Function()? onTap;
  Color tileColor;
  Color textColor;
  


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: tileColor,
        border: Border.all(
          width: 1,
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
      
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: ListTile(
        title: AppText(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          text: text,
        ),
        trailing:  Icon(
          Icons.arrow_forward_ios,
          color: textColor,
          size: 9,
        ),
        onTap: onTap,
      ),
    );
  }
}

class FavTeamMenuListTile extends StatelessWidget {

  FavTeamMenuListTile (
    {
      super.key,
      required this.teamName,
      this.onTap,
      this.teamLogoURL
      
    }
  );

  String teamName;
  Function()? onTap;
  String? teamLogoURL;
  


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
      
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: ListTile(
        leading: teamLogoURL == null ? null : 
        Image.network(
          teamLogoURL!,
          width: 30,
          height: 30,
        ),
        title: AppText(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          text: teamName,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 9,
        ),
        onTap: onTap,
      ),
    );
  }
}


class PlayerListTile extends StatelessWidget {

  PlayerListTile (
    {
      super.key,
      required this.playerName,
      required this.teamName,
      this.onTap
    }
  );

  String playerName;
  String teamName;
  Function()? onTap;

  


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 246, 245, 245),
        ),
      ),
      child: ListTile(
        title: AppText(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          text: playerName,
        ),
        subtitle: AppText(
          color: Colors.black,
          fontSize: 9,
          fontWeight: FontWeight.w300,
          text: teamName,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size:9
        ),
        onTap: onTap,
      ),
    );
  }
}


class ClubListTile extends StatelessWidget {

  ClubListTile (
    {
      super.key,
      required this.teamName,
      this.onTap,
      this.teamLogoURL
    }
  );

  String teamName;
  Function()? onTap;
  String? teamLogoURL;

  


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 232, 229, 229),
        ),
      ),
      child: ListTile(
        // if teamLogoURL is null, then display nothing
        leading: teamLogoURL == null ? null : 
        Image.network(
          teamLogoURL!,
          width: 50,
          height: 50,
        ),
        title: AppText(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          text: teamName,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 9,
        ),
        onTap: onTap,
      ),
    );
  }
}

class NewsListTile extends StatelessWidget {

  NewsListTile (
    {
      super.key,
      required this.newsMap,
      this.onTap,
    }
  );

  Map <String, dynamic> newsMap;
  Function()? onTap;

  


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 232, 229, 229),
        ),
      ),
      child: ListTile(
        // if news item cover pic is null or an empty string, then display nothing
        leading: newsMap['cover_pic'] == null || newsMap['cover_pic'] == '' ? null :
        Image.network(
          newsMap['cover_pic'],
          width: 50,
          height: 50,
        ),
        title: AppText(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          text: newsMap['title'],
        ),
        subtitle: AppText(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.w300,
          text:  DateFormat('EEE d MMM yyyy').format(DateTime.parse(newsMap['time_published'])),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 9,
        ),
        onTap: onTap,
      ),
    );
  }
}


class FixturesListTile extends StatelessWidget {

  FixturesListTile (
    {
      super.key,
      required this.title,
      required this.subtitle,
      this.onTap
    }
  );

  String title;
  String subtitle;
  Function()? onTap; 


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 246, 243, 243),
        ),
      ),
      child: Center(
        child: ListTile(
          title: AppText(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            text: title,
          ),
          subtitle: AppText(
            color: Colors.black,
            fontSize: 9,
            fontWeight: FontWeight.w300,
            text: subtitle,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 9,
          ),
          onTap: onTap,
        ),
      )
    );
  }
}


class GoalListTile extends StatelessWidget {

  GoalListTile (
    {
      super.key,
      required this.goal,
      required this.assist,
    }
  );

  Map<String, dynamic> goal = {};
  Map<String, dynamic> assist = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: const Padding(
          padding: EdgeInsets.only(left: 30,),
          child: Icon(
            Icons.sports_soccer,
            size: 14,
          ),
        ),
        title: AppText(
          text: "${goal['minute_scored']}'",
          fontWeight: FontWeight.bold,
          fontSize: 12, 
          color: Colors.black,
        ),
        subtitle: RichText(
          text: TextSpan(
            children: [

              TextSpan(
                text: "${goal['fname']}",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 12, 
                  color: Colors.black,
                ),
              ),

              TextSpan(
                text: " ${goal['lname']}",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 14, 
                  color: Colors.black,
                ),
              ),

              TextSpan(
                text: assist.isEmpty ? "" : " (${assist['fname']} ${assist['lname']})",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 12, 
                  color: Colors.black,
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}


class StartingXIListTile extends StatelessWidget {

  StartingXIListTile (
    {
      super.key,
      required this.player,
      this.onTap
    }
  );

  Function()? onTap;

  Map<String, dynamic> player = {};

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AppText (
        text: '${player['fname']} ${player['lname']}',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      tileColor: Colors.grey[200],
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: 9,

      ),
      onTap: onTap,
   );
  }
}


class PlayerDetailListTile extends StatelessWidget {

  PlayerDetailListTile (
    {
      super.key,
      required this.heading,
      required this.value,
    }
  );



  String heading;
  String value;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 245, 242, 242),
        ),
      ),
      child: ListTile(
        title: AppText (
          text: heading,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        trailing: AppText (
          text: value,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      )
    );
  }
}

class DrawerListTile extends StatelessWidget {

  DrawerListTile (
    {
      super.key,
      required this.text,
      required this.onTap,
    }
  );



  String text;
  Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AppText(
        text: text, 
        fontWeight: FontWeight.w400, 
        fontSize: 13, 
        color: Colors.black
      ),
      onTap: onTap
    );
  }
}


class AdminListTile extends StatelessWidget {

  AdminListTile (
    {
      super.key,
      required this.title,
      required this.subtitle,
      required this.editOnTap,
      required this.deleteOnTap,
    }
  );



  String title;
  String subtitle;
  Function()? editOnTap;
  Function()? deleteOnTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 245, 242, 242),
        ),
      ),
      child: ListTile(
        title: AppText (
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        subtitle: AppText(
          text: subtitle,
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: Colors.grey,
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'edit',
                child: AppText(
                  text: 'Edit', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: AppText(
                  text: 'Delete', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
            ];
          },
          onSelected: (String value) {
            if (value == 'edit') {
              editOnTap!();
            } else if (value == 'delete') {
              deleteOnTap!();            
            }
          },
        ),
      )
    );
  }
}


class PlayerAdminListTile extends StatelessWidget {

  PlayerAdminListTile (
    {
      super.key,
      required this.title,
      required this.subtitle,
      required this.editOnTap,
      required this.deleteOnTap,
      required this.changeClubOnTap
    }
  );



  String title;
  String subtitle;
  Function()? editOnTap;
  Function()? deleteOnTap;
  Function()? changeClubOnTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 245, 242, 242),
        ),
      ),
      child: ListTile(
        title: AppText (
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        subtitle: AppText(
          text: subtitle,
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: Colors.grey,
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'edit',
                child: AppText(
                  text: 'Edit', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: AppText(
                  text: 'Delete', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
              const PopupMenuItem<String>(
                value: 'changeClub',
                child: AppText(
                  text: 'Change Club', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
            ];
          },
          onSelected: (String value) {
            if (value == 'edit') {
              editOnTap!();
            } 
            else if (value == 'delete') {
              deleteOnTap!();            
            }
            else if (value == 'changeClub') {
              changeClubOnTap!();            
            }
          },
        ),
      )
    );
  }
}

class AdminListTileWithoutSubtitle extends StatelessWidget {

  AdminListTileWithoutSubtitle (
    {
      super.key,
      required this.title,
      required this.editOnTap,
      required this.deleteOnTap,
    }
  );



  String title;
  Function()? editOnTap;
  Function()? deleteOnTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 245, 242, 242),
        ),
      ),
      child: ListTile(
        title: AppText (
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),

        trailing: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'edit',
                child: AppText(
                  text: 'Edit', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: AppText(
                  text: 'Delete', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
            ];
          },
          onSelected: (String value) {
            if (value == 'edit') {
              editOnTap!();
            } else if (value == 'delete') {
              deleteOnTap!();            
            }
          },
        ),
      )
    );
  }
}


class AdminListTileWithOnTap extends StatelessWidget {

  AdminListTileWithOnTap (
    {
      super.key,
      required this.title,
      required this.subtitle,
      required this.onTap,
      required this.editOnTap,
      required this.deleteOnTap,
    }
  );



  String title;
  String subtitle;
  Function()? onTap;
  Function()? editOnTap;
  Function()? deleteOnTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 245, 242, 242),
        ),
      ),
      child: ListTile(
        title: AppText (
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        subtitle: AppText(
          text: subtitle,
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: Colors.grey,
        ),
        onTap: onTap,
        trailing: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'edit',
                child: AppText(
                  text: 'Edit', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: AppText(
                  text: 'Delete', 
                  fontWeight: FontWeight.normal, 
                  fontSize: 10, 
                  color: Colors.black
                ),
              ),
            ];
          },
          onSelected: (String value) {
            if (value == 'edit') {
              editOnTap!();
            } else if (value == 'delete') {
              deleteOnTap!();            
            }
          },
        ),
      )
    );
  }
}


class AdminStartingXITile extends StatelessWidget {

  AdminStartingXITile (
    {
      super.key,
      required this.fname,
      required this.lname,
      required this.trailingOnPressed,
    }
  );


  String fname;
  String lname;
  Function()? trailingOnPressed;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: fname,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w300,
                fontSize: 12, 
                color: Colors.black,
              ),
            ),

            TextSpan(
              text: ' $lname',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 13, 
                color: Colors.black,
              ),
            ),
          ]
        )
      ),
      
      tileColor: Colors.grey[200],
      trailing: IconButton(
        // minus icon
        icon: const Icon(
          Icons.remove,
          size: 13,
        ),         
        onPressed: () {
          trailingOnPressed!();                 
        },
      )
    );
  }
}



class FixturesGraphicListTile extends StatelessWidget {

  FixturesGraphicListTile (
    {
      super.key,
      required this.homeTeam,
      required this.awayTeam,
      required this.gameDetails,
      this.onTap
    }
  );

  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;
  final Map<String, dynamic> gameDetails;
  Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 246, 243, 243),
        ),
      ),
      child: ListTile(
        title: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Home team
              AppText(
                text: homeTeam['team_name_abbrev'],
                fontWeight: FontWeight.w400,
                fontSize: 14, 
                color: Colors.black,
              ),

              // home team logo
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Image.network(
                  homeTeam['team_logo_url'],
                  width: 25,
                  height: 25,
                ),
              ),

              const Text("     "),

              // Start time
              AppText(
                text: gameDetails['start_time'].toString().substring(0, 5),
                fontWeight: FontWeight.w500,
                fontSize: 19, 
                color: Colors.black,
              ),

              const Text("     "),

              // away team
              AppText(
                text: awayTeam['team_name_abbrev'],
                fontWeight: FontWeight.w400,
                fontSize: 14, 
                color: Colors.black,
              ),

              // away team logo
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Image.network(
                  awayTeam['team_logo_url'],
                  width: 25,
                  height: 25,
                ),
              ),

              // space
              const Text("     "),

              // forward arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 9,
              ),

            ],
          )
        ),

        // competition name
        subtitle: Container(
          margin: const EdgeInsets.only(top: 5),
          child: Center(
            child: AppText (
              text: gameDetails['stage_name'] == null ? '${gameDetails['competition_name']}' : '${gameDetails['competition_name']} - ${gameDetails['stage_name']}',
              fontWeight: FontWeight.w400,
              fontSize: 9,
              color: const Color.fromARGB(255, 71, 70, 70),
            )
          )
        ),
        
      )
    );
  }
}


class ResultsGraphicListTile extends StatelessWidget {

  ResultsGraphicListTile (
    {
      super.key,
      required this.homeTeam,
      required this.awayTeam,
      required this.homeTeamScore,
      required this.awayTeamScore,
      required this.gameDetails,
      this.onTap
    }
  );

  final Map<String, dynamic> homeTeam;
  final Map<String, dynamic> awayTeam;
  int homeTeamScore;
  int awayTeamScore;
  final Map<String, dynamic> gameDetails;

  Function()? onTap;


   @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 246, 243, 243),
        ),
      ),
      child: ListTile(
        title: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Home team
              AppText(
                text: homeTeam['team_name_abbrev'],
                fontWeight: FontWeight.w400,
                fontSize: 14, 
                color: Colors.black,
              ),

              // home team logo
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Image.network(
                  homeTeam['team_logo_url'],
                  width: 25,
                  height: 25,
                ),
              ),

              const Text("     "),

              // Start time
              AppText(
                text: '$homeTeamScore - $awayTeamScore',
                fontWeight: FontWeight.w500,
                fontSize: 19, 
                color: Colors.black,
              ),

              const Text("     "),

              // away team
              AppText(
                text: awayTeam['team_name_abbrev'],
                fontWeight: FontWeight.w400,
                fontSize: 14, 
                color: Colors.black,
              ),

              // away team logo
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Image.network(
                  awayTeam['team_logo_url'],
                  width: 25,
                  height: 25,
                ),
              ),

              // space
              const Text("     "),

              // forward arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 9,
              ),

            ],
          )
        ),

        // competition name
        subtitle: Container(
          margin: const EdgeInsets.only(top: 5),
          child: Center(
            child: AppText (
              text: gameDetails['stage_name'] == null ? '${gameDetails['competition_name']}' : '${gameDetails['competition_name']} - ${gameDetails['stage_name']}',
              fontWeight: FontWeight.w400,
              fontSize: 9,
              color: const Color.fromARGB(255, 71, 70, 70),
            )
          )
        ),
        
      )
    );
  }
}