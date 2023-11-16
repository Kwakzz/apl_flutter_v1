
import 'package:apl/helper_classes/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helper_classes/text.dart';
import '../requests/news_item/get_news_item_req.dart';


class ViewNewsItem extends StatefulWidget {
  const ViewNewsItem(
    {
      super.key,
      required this.newsItemMap
    }
  );

  final Map<String, dynamic> newsItemMap;

  @override
  _ViewNewsItemState createState() => _ViewNewsItemState();
}

class _ViewNewsItemState extends State<ViewNewsItem> {

  Map<String, dynamic> newsItem = {};


  @override
  Widget build(BuildContext context) {




      return Scaffold(
        appBar: CustomAppbar(
          pageName: 'News',
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          prevContext: context,
        ),

        body: FutureBuilder(
          future: getNewsItemById(widget.newsItemMap['news_item_id']),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return NewsItemDetails(
                newsItem: snapshot.data,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        )

      );
  }

}


class NewsItemDetails extends StatelessWidget {


  const NewsItemDetails(
    {
      super.key,
      required this.newsItem,
    }
  );

  final Map<String, dynamic> newsItem;



  @override
  Widget build(BuildContext context) {
  
      return Scaffold(
        body: ListView(

          children: [

            // news item tag
            Container(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              margin: const EdgeInsets.only(bottom: 20),
              color: const Color.fromARGB(255, 71, 108, 255),
              child: Center(
                child: AppText(
                  text: newsItem['news_tag_name']??'',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 255, 255, 255),
                )
              )
            ),

            // date published
            // get date from timestamp
            // date should be in format: Monday, 1st January 2021
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: AppText(
                text: DateFormat('EEE d MMM yyyy').format(DateTime.parse(newsItem['time_published'])),
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              )
            ),

            const SizedBox(height: 20,),

            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: AppText(
                text: newsItem['title']??'',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )
            ),

            

            
       

            // cover image
            Container(
              margin: const EdgeInsets.only(top: 20),
              // if cover pic is null or an empty string, don't show the image
              
              child: newsItem['cover_pic'] == null || newsItem['cover_pic'] == '' ? Container() : AspectRatio(
              aspectRatio: 14 / 9,
              child: Image.network(
                newsItem['cover_pic'],
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              )
            ),
            ),

            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: AppText(
                text: newsItem['content']??'',
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              )
            ),




          ]
        )

    
      );
    
  
  }
}