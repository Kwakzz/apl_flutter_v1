import 'package:apl/helper_classes/web_view.dart';
import 'helper_classes/custom_appbar.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage(
    {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: CustomAppbar(
        pageName: 'Privacy Policy',
        icon: const Icon(Icons.arrow_back),
        prevContext: context,
      ),
      body: WebViewPage(url: 'https://3.8.171.188/backend/privacy_policy.php'),
      
    );
  }
}
