import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:next_hour/loading/loading_screen.dart';


//  This page will call when user is not connected to the mobile internet or wi-fi

class NoNetwork extends StatefulWidget {
  @override
  NoNetworkState createState() => NoNetworkState();
}

class NoNetworkState extends State<NoNetwork> {

//  Outline button to reload app when app is again connected to network
  Widget outlineButton(){
    return OutlineButton(
      color: Color.fromRGBO(20, 20, 20, 1.0),
      child: Text("Tap to Reload"),
//              This will redirect you to Loading screen when you connect to internet and tap on the button
      onPressed: (){
        var router = new MaterialPageRoute(
            builder: (BuildContext context) => new LoadingScreen());
        Navigator.of(context).push(router);
      },
    );
  }

//  Message when app is not connected to network.
  Widget messageNoNetwork(){
    return Padding(padding: EdgeInsets.only(left: 70.0, right: 70.0),
      child: Text("You are not connected to the internet. Make sure you connect to Wi-Fi or mobile network. ",
        style: TextStyle(height: 1.5,color: Colors.white70),
        textAlign: TextAlign.center,),);
  }

//  Icon will show when app is not conned to network
  Widget noNetworkIcon(){
    return Container(
      margin: EdgeInsets.only(right: 30.0),
      child: Icon(FontAwesomeIcons.wifi, size: 150.0, color: Color.fromRGBO(70, 70, 70, 1.0),),);
  }

//  Scaffold body
  Widget scaffoldBody(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          noNetworkIcon(),
          SizedBox(
            height: 25.0,
          ),
          messageNoNetwork(),
          SizedBox(
            height: 25.0,
          ),
          outlineButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: scaffoldBody(),
    );
    // return
  }
}

