import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_hour/ui/app_settings.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/utils/icons.dart';
import 'package:next_hour/model/video_data.dart';
import 'package:next_hour/ui/no_network.dart';
import 'package:next_hour/player/player.dart';
import 'package:next_hour/player/playerMovieTrailer.dart';
import 'package:next_hour/utils/item_video_box.dart';
import 'package:next_hour/utils/item_header_diagonal.dart';
import 'package:next_hour/utils/item_rating.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoDetailHeader extends StatefulWidget {

  VideoDetailHeader(this.game);
  final VideoDataModel game;
  @override
  VideoDetailHeaderState createState() => VideoDetailHeaderState();
}

class VideoDetailHeaderState extends State<VideoDetailHeader> {
  Connectivity connectivity;
  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult> subscription;
  var _connectionStatus = 'Unknown';
  bool boolValue;

  Future<String> addBoolToSF() async {
//    print("added");
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', isSwitched);
    return null;
  }

  getValuesSF() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      boolValue = prefs.getBool('boolValue');
    });

//    print("va2 $boolValue");
  }

  Future<void> _networkAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
              contentPadding: const EdgeInsets.all(16.0),
              title: Text('Network Connection!'),
              content: const Text('You are using mobile network'+'\n'+'Change app setting or switch enable Wi-fi'),
              actions: <Widget>[
//                FlatButton(
//                  child: Text('Yes',style: TextStyle(fontSize: 16.0),),
//                  onPressed: () {
//                    setState(() {
//                      isSwitched=true;
//                    });
//                    addBoolToSF();
//                    Navigator.of(context).pop();
//                  },
//                ),
                FlatButton(
                  child: Text('Close',style: TextStyle(fontSize: 16.0),),
                  onPressed: () {
                    getValuesSF();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(_connectionStatus);
          getValuesSF();
          checkConnectionStatus = result.toString();
          if (result == ConnectivityResult.wifi) {

            setState(() {
              _connectionStatus='Wi-Fi';
            });

          }else if( result == ConnectivityResult.mobile){
            _connectionStatus='Mobile';
          }
          else {
            var router = new MaterialPageRoute(
                builder: (BuildContext context) => new NoNetwork());
            Navigator.of(context).push(router);
          }
        });
  }

  void _showMsg(){
    Fluttertoast.showToast(msg: "You are not subscribed.");
  }

  void _onTapPlay(){
print(_connectionStatus);
    if(boolValue == true){
      if(_connectionStatus == 'Wi-Fi'){

        var router = new MaterialPageRoute(
            builder: (BuildContext context) =>
            new PlayerMovie(
                id : widget.game.id,
                type: widget.game.datatype

            )
        );
        Navigator.of(context).push(router);
      }
      else{
        _networkAlert(context);
      }

    }
    else{
      var router = new MaterialPageRoute(
          builder: (BuildContext context) =>
          new PlayerMovie(
              id : widget.game.id,
              type: widget.game.datatype

          )
      );
      Navigator.of(context).push(router);
//      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]).then((_){
//        Navigator.of(context).push(router);
//      }
//      );
//      var router = new MaterialPageRoute(
//          builder: (BuildContext context) =>
//          new PlayerMovie(
//              id : widget.game.id,
//              type: widget.game.datatype
//          ));
//
////                                   SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]).then((_){
////                                        CircularProgressIndicator();
////                                      });
//    Navigator.of(context).push(router);
    }
  }

  void _onTapTrailer(){
    var router = new MaterialPageRoute(
        builder: (BuildContext context) =>

        new PlayerMovieTrailer(
            id : widget.game.id,
            type : widget.game.datatype

        ));
//    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]).then((_){
      Navigator.of(context).push(router);
//    });
  }


  @override
  Widget build(BuildContext context) {
    isSwitched = true;
    var theme = Theme.of(context);
    return new Stack(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: _buildDiagonalImageBackground(context),
        ),
       headerDecorationContainer(),
        new Positioned(
          top: 0.0,
          left: 0.0,
          child: new BackButton(color: Colors.white),
        ),
        new Positioned(
          top: 180.0,
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: headerRow(theme),
        ),
        new Positioned(
          top: 200.0,
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: headerButtonRow(theme),
        ),
      ],
    );
  }
  Widget headerRow(theme){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  widget.game.name,
                  style: Theme.of(context).textTheme.subhead,
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(direction: Axis.horizontal,children: <Widget>[
                  Flexible(flex:1,child: new RatingInformation(widget.game),)
                ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget headerButtonRow(theme){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget headerDecorationContainer(){
    return  Container(
      height: 262.0,
      decoration: BoxDecoration(
        //                  color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Color.fromRGBO(34, 34, 34, 1.0).withOpacity(0.1),
                Color.fromRGBO(34, 34, 34, 1.0),
              ],
              stops: [
                0.3,
                0.8
              ])),
    );
  }

  Widget header(theme){

    return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: new Column(
          children: <Widget>[
            new MaterialButton(
              onPressed: status==1?_onTapPlay : _showMsg,
              color: Colors.red,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(
                        0.0, 0.0, 5.0, 0.0),
                  ),
                  Expanded(
                    flex: 1,
                    child: new Text(
                      "Play",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.9,
                          color: Colors.white,
                          
                        // color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(
                  6.0, 0.0, 12.0, 0.0),
              shape: new RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.circular(10.0)),
              splashColor: Colors.red,
            ),

widget.game.datatype == 'M' ? new MaterialButton(
              onPressed: _onTapTrailer,
              color: Colors.orange,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: new Icon(Icons.play_arrow,
                        color: Colors.black),
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(
                        0.0, 0.0, 5.0, 0.0),
                  ),
                  Expanded(
                    flex: 1,
                    child: new Text(
                      "WATCH TRAILER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.9,
                        color: Colors.black,
                        // color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(
                  6.0, 0.0, 12.0, 0.0),
              shape: new RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.circular(10.0)),
              splashColor: Colors.black12,
            ) : SizedBox.shrink(),


            /*
            widget.game.datatype == 'M' ? new OutlineButton(
              onPressed: _onTapTrailer,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: new Icon(Icons.play_arrow,
                        color: Colors.black),
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(
                        0.0, 0.0, 5.0, 0.0),
                  ),
                  Expanded(
                    flex: 1,
                    child: new Text(
                      "WATCH TRAILER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.9,
                        color: Colors.black,
                        // color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(
                  6.0, 0.0, 12.0, 0.0),
              shape: new RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.circular(10.0)),
              borderSide: new BorderSide(
                  color: Colors.white70, width: 2.0),
              highlightColor: theme.accentColor,
              highlightedBorderColor: theme.accentColor,
              splashColor: Colors.black12,
              highlightElevation: 0.0,
            ) : SizedBox.shrink(),
            */
          ],
        )
    );
  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new FadeInImage.assetNetwork(
        image: widget.game.cover,
        placeholder: "assets/placeholder_cover.jpg",
        width: screenWidth,
        height: 260.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0x00FFFFFF),
    );
  }
}
