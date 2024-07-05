import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapWebview extends StatefulWidget {
  final Function(String) onLocationSelected;

  const MapWebview({
    Key? key,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<MapWebview> createState() => _MapWebviewState();
}

class _MapWebviewState extends State<MapWebview> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'flutter_inappwebview',
        onMessageReceived: (message) {
          widget.onLocationSelected(message.message);
          Navigator.of(context).pop();
        },
      );
    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/map.html');
    _webViewController.loadHtmlString(fileText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
