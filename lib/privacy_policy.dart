 import 'package:apl/helper_classes/text.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Duplicate import removed
import 'helper_classes/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // Import for iOS features.

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    try {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse('http://3.8.171.188/backend/privacy_policy.php'));
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: CustomAppbar(
        pageName: 'Privacy Policy',
        icon: const Icon(Icons.arrow_back),
        prevContext: context,
      ),

      body: WebViewWidget(controller: controller),
    );
  }
}
