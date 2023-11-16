import 'package:apl/helper_classes/text.dart';
import 'package:flutter/material.dart';

class LatestNews extends StatelessWidget {
  const LatestNews({
    Key? key,
    required this.newsItem,
    required this.onTapped
  }) : super(key: key);

  final Map<String, dynamic> newsItem;
  final Function()? onTapped;

  @override
  Widget build(BuildContext context) {

    if (newsItem.isEmpty){
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), 
        strokeWidth: 2, 
      );
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      color: const Color.fromARGB(255, 0, 53, 91),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // news item cover pic
            AspectRatio(
              aspectRatio: 14 / 9,
              child: newsItem['cover_pic'] == null || newsItem['cover_pic'] == '' ? 
              const Icon(Icons.image_not_supported, size: 20) : Image.network(
                newsItem['cover_pic'],
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return const Center(
                    child: AppText(
                      text: 'Error loading image', 
                      fontWeight: FontWeight.w400, 
                      fontSize: 15,
                      color: Colors.white
                    )
                  );
                }
              )
            ),

            Container(
              margin: const EdgeInsets.only(left:10, top: 12),
              child: GestureDetector(
                onTap: onTapped,
                child: AppText(
                  text: newsItem['news_tag_name']??'',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                )
              ),
            ),

            // news item title
            Container(
              margin: const EdgeInsets.only(left:10, top: 12, bottom: 12, right: 10),
              child: GestureDetector(
                onTap: onTapped,
                child: AppText(
                  text: newsItem['title']??'',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                )
              ),
            ),

            // news item subtitle
            Container(
              margin: const EdgeInsets.only(left:10, right: 10),
              child: AppText(
                text: newsItem['subtitle']??'',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),

          ],
        )
    );
  }
}
