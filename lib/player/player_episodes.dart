import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../global.dart';

var x;
class PlayerEpisode extends StatefulWidget{
  PlayerEpisode({this.id});
  final int id;

  @override
  _PlayerEpisodeState createState() => _PlayerEpisodeState();
}

class _PlayerEpisodeState extends State<PlayerEpisode>{

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return new Scaffold(
        body: Container(
          width: width,
          height: height,
          child: WebView(
            initialUrl: APIData.episodePlayer+'$userId/$code/${widget.id}',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        )
//
    );

  }
}

class LocalLoader{
  Future<String> loadLocal() async {
    return await rootBundle.loadString(APIData.moviePlayer+'$userId/$code/$x');
  }
}