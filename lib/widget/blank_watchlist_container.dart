import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WatchlistContainer extends StatelessWidget {

//  Empty watchlist container message
  Widget emptyWatchContainer(){
    return Padding(padding: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Text("Add anything to your list so you can easily find them later.",
        style: TextStyle(height: 1.5,color: Colors.white70),
        textAlign: TextAlign.center,),);
  }

//  Empty watchlist icon
  Widget emptyWatchlistIcon(){
    return Container(
      child: Icon(FontAwesomeIcons.solidCheckCircle, size: 150.0, color: Color.fromRGBO(70, 70, 70, 1.0),),
    );
  }

//  Empty watchlist column
  Widget emptyWatchColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        emptyWatchlistIcon(),
        SizedBox(
          height: 25.0,
        ),
        emptyWatchContainer(),
      ],
    );
  }
  Widget appBar(){
    return AppBar(
      title: Text("My Watchlist",style: TextStyle(fontSize: 16.0),),
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor:
      Color.fromRGBO(34,34,34, 1.0).withOpacity(0.98),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        alignment: Alignment.center,
        child: emptyWatchColumn(),
      ),
    );
  }
}
