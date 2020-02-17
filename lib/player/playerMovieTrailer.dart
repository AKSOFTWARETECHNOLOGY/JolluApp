import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../global.dart';

var x;
class PlayerMovieTrailer extends StatefulWidget{
  PlayerMovieTrailer({this.id,this.type});
  final int id;
  final type;
  @override
  _PlayerMovieTrailerState createState() => _PlayerMovieTrailerState();
}

class _PlayerMovieTrailerState extends State<PlayerMovieTrailer>{

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
            initialUrl: APIData.trailerPlayer+'$userId/$code/${widget.id}',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        )
    );
  }
}
