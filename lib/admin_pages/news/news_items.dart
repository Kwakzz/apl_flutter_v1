
import 'dart:convert';

import 'package:apl/admin_pages/news/add_news_item.dart';
import 'package:apl/admin_pages/news/edit_news_item.dart';
import 'package:apl/helper_classes/custom_button.dart';
import 'package:apl/helper_classes/custom_list_tile.dart';
import 'package:apl/helper_classes/error_handling.dart';
import 'package:apl/helper_classes/text.dart';
import 'package:apl/requests/news_item/delete_news_item_req.dart';
import 'package:apl/requests/news_item/get_all_news_items_req.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helper_classes/custom_dialog_box.dart';


class NewsItems extends StatefulWidget {
  const NewsItems({super.key});

  @override
  _NewsItemsState createState() => _NewsItemsState();
}

class _NewsItemsState extends State<NewsItems> {

  List<Map<String, dynamic>> newsItems = [];

  @override
  void initState() {
    super.initState();

    getAllNewsItems().then((result) {
      setState(() {
        newsItems = result;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    // if the list of news items is empty, return "No news items found"
    if (newsItems.isEmpty) {
      return  Column(

        children: [
          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewsItem(
                    pageName: 'Add News Item',
                  )
                ),
              );
            },
            text: "Add News Item"
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const AppText(
                text: 'No news item found',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )
            )
          ),

        ],
    
      );
    }

    return Scaffold(
      body: Column(
        children: [

          SmallAddButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewsItem(
                    pageName: 'Add News Item',
                  )
                ),
              );
            },
            text: "Add News Item"
          ),

          // List of news articles
          Expanded(
            child: ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (
                BuildContext context, 
                int index
              ) {
                final newsItem = newsItems[index];

                return AdminListTile(
                  title: newsItem['title'], 
                  // date of time published
                  subtitle: DateFormat('dd/MM/yyyy').format(
                    DateTime.parse(newsItem['time_published'])
                  ),
                  editOnTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => (
                          EditNewsItem(
                            pageName: 'Edit News Item',
                            newsItem: newsItem,
                          )
                        )
                      )
                    );
                  }, 
                  deleteOnTap: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return DeleteConfirmationDialogBox(
                          title: "Delete News Item", 
                          content: "Are you sure you want to this news item?",
                          onPressed: () async {

                          Map <String, dynamic> response = await deleteNewsItem(jsonEncode(newsItem));

                          if (!mounted) return;

                          if (response['status']) {

                            // refresh the page
                            getAllNewsItems().then((result) {
                              setState(() {
                                newsItems = result;
                              });
                            });
                            
                          } else {

                            ErrorHandling.showError(
                              response['message'], 
                              context,
                              'Error'
                            );
                          }
                        }
                        );
                      }
                    );
                  },
                );
              }
            ),
          )
        ]
      )
    );
  }
}