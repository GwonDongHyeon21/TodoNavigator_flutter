import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapWebview extends StatefulWidget {
  const MapWebview({Key? key}) : super(key: key);

  @override
  State<MapWebview> createState() => _MapWebviewState();
}

class _MapWebviewState extends State<MapWebview> {
  late WebViewController _webViewController;

  @override
  void initState() {
    _webViewController = WebViewController()
      ..loadRequest(Uri.parse('https://www.google.co.kr/maps/?hl=ko/'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
