
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebviewPage extends StatefulWidget {

  String url = '';
  WebviewPage(this.url,{Key? key}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {

  WebViewController? _controller;
  String _navTitle = '';

  _getTitle () async{
    String title = await _controller?.getTitle() ?? '';
    setState(() {
      _navTitle = title;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_navTitle),
      ),
      body: Container(
        child: WebView(
          initialUrl: this.widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller){
            _controller = controller;
          },
          onPageFinished: (String url){
            _getTitle();
          },
          navigationDelegate: (NavigationRequest navigation){
            print(navigation.url);
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}

