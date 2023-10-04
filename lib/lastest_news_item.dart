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
    return 
    Container(
      padding: const EdgeInsets.only(bottom: 80),
      color: const Color.fromARGB(255, 0, 53, 91),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 14 / 9,
              child: newsItem['cover_pic'] == null || newsItem['cover_pic'] == '' ? Container() : Image.network(
                newsItem['cover_pic'],
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              )
            ),
            Container(
              margin: const EdgeInsets.only(left:10, top: 12, bottom: 5),
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
            Container(
              margin: const EdgeInsets.only(left:10),
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
