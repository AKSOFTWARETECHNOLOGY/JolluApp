import 'package:flutter/material.dart';

class RateUs extends StatelessWidget {
  RateUs(this._scaffoldKey);
  final _scaffoldKey;

//  Rate text
  Widget rateText(){
    return Text(
      "Rate",
      style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          color: Colors.white
        // color: Colors.white
      ),
    );
  }

//  Rate us column
  Widget rateUsTabColumn(){
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star_border,
          size: 30.0,
          color: Colors.white,
        ),
        new Padding(
          padding:
          const EdgeInsets.fromLTRB(
              0.0, 0.0, 0.0, 10.0),
        ),
        rateText(),
      ],
    );
  }

  void onTappingOk(context){
    final snackBar = SnackBar(content: Text('This feature is not availabe'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: new InkWell(
          onTap: () {
            onTappingOk(context);
          },
          child: rateUsTabColumn(),
        ),
        color: Colors.transparent,
      ),
    );
  }
}