import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Earthquake Report'),
    //   ),
    //   body: Container(
    //     child: WebView(
    //       initialUrl:
    //           'https://www.bmkg.go.id/gempabumi/antisipasi-gempabumi.bmkg',
    //     ),
    //   ),
    // );
    return WebviewScaffold(
      appBar: AppBar(
        // elevation: 30,
        // backgroundColor: Colors.white,
        title: Text(
          'Eartquake Report',
          // style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      url: 'https://www.bnpb.go.id/',
      withJavascript: true,
    );
  }
}
