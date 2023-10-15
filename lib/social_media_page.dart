import 'package:apl/helper_classes/web_view.dart';
import 'helper_classes/custom_appbar.dart';
import 'package:flutter/material.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage(
    {
      super.key,
      required this.url,
    }
  );

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: CustomAppbar(
        pageName: 'Social Media',
        icon: const Icon(Icons.arrow_back),
        prevContext: context,
      ),
      body: WebViewPage(url: url),
      
    );
  }
}
