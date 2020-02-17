import 'package:flutter/material.dart';

//  When history is not available then this widget will called
class BlankHistoryContainer extends StatelessWidget {

//  Blank history icon
  Widget blankHistoryIcon(){
    return Container(
      margin: EdgeInsets.only(top: 130.0),
      child: Icon(Icons.history, size: 150.0, color: Color.fromRGBO(70, 70, 70, 1.0),),
    );
  }
//  Blank history message
  Widget blankHistoryMessage(){
    return Padding(padding: EdgeInsets.only(left: 50.0, right: 50.0),
      child: Text("No History Available.",
        style: TextStyle(height: 1.5,color: Colors.white70),),);
  }

//  Blank history column
  Widget blankHistoryColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        blankHistoryIcon(),
        SizedBox(
          height: 25.0,
        ),
        blankHistoryMessage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: blankHistoryColumn(),
    );
  }
}
