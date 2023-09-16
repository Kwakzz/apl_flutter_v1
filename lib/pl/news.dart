import 'package:apl/pl/club_details.dart';
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/pl/view_news_item.dart';
import 'package:apl/requests/news_item/get_all_news_items_req.dart';
import 'package:flutter/material.dart';
import '../../requests/teams/get_teams_req.dart';


class News extends StatefulWidget {
  const News(
    {
      super.key,
      required this.pageName
    }
  );

  final String pageName;

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

  List<Map<String, dynamic>> newsItems = [];


  @override
  /// This function is called when the page loads.
  /// It calls the function to get the teams.
  /// It also sets the filteredTeams list to the teams list.
  void initState() {
    super.initState();

    // Call the function to get the teams when the page loads
    getAllNewsItems().then((result) {
      try{
        setState(() {
          newsItems = result;
        });
      } catch (e) {
        return;
      }
    });

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      // app bar
      appBar: CustomAppbar(
        pageName: widget.pageName,
        icon: const Icon(Icons.arrow_back),
        prevContext: context,
      ),

      body: Column(
        children: [
          // List of teams
          Expanded(
            child: ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                final newsItem = newsItems[index];
          
                
                return NewsListTile(
                  newsMap: newsItem,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewNewsItem(
                          newsItemMap: newsItem,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ),
        ]
      )
    );
  }
}