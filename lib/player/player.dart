import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import '../global.dart';

class PlayerMovie extends StatefulWidget {
  PlayerMovie({this.id, this.type});

  final int id;
  final String type;

  @override
  _PlayerMovieState createState() => _PlayerMovieState();
}

class _PlayerMovieState extends State<PlayerMovie> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var playerResponse;
  var status;
  GlobalKey sc = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    this.loadLocal();
  }

  Future<String> loadLocal() async {
    playerResponse = await http.get(widget.type == 'T'
        ? APIData.tvSeriesPlayer + '$userId/$code/$ser'
        : APIData.moviePlayer + '$userId/$code/${widget.id}');
    print("status: ${playerResponse.statusCode}");
    setState(() {
      status = playerResponse.statusCode;
    });

    var responseUrl = playerResponse.body;
    return responseUrl;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
   JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
      return JavascriptChannel(
          name: 'Toaster',
          onMessageReceived: (JavascriptMessage message) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          });
    }

    return new Scaffold(
        key: sc,
        body: status == 200
            ? Container(
                width: width,
                height: height,
                child: WebView(
                    initialUrl: widget.type == 'T'
                        ? APIData.tvSeriesPlayer + '$userId/$code/$ser'
                        : APIData.moviePlayer +
                            '$userId/$code/${widget.id}',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    javascriptChannels: <JavascriptChannel>[
                      _toasterJavascriptChannel(context),
                    ].toSet()))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
