import 'package:flutter/material.dart';
class DownloadPage extends StatelessWidget {
  DownloadPage(this._scaffoldKey);
  final _scaffoldKey;

  void onTapOk(context){
    final snackBar = SnackBar(content: Text('This feature is not availabe'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),);
    Scaffold.of(context).showSnackBar(snackBar);
  }
//  Download text
  Widget downloadText(){
    return Text(
      "Download",
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
// download icon
  Widget downloadIcon(){
    return Icon(
      Icons.arrow_downward,
      size: 30.0,
      color: Colors.white,
    );
  }
// column
  Widget column(){
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: <Widget>[
        downloadIcon(),
        new Padding(
          padding:
          const EdgeInsets.fromLTRB(
              0.0, 0.0, 0.0, 10.0),
        ),
        downloadText(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: new InkWell(
          onTap: () {
            onTapOk(context);
          },
          child: column(),
        ),
        color: Colors.transparent,
      ),
    );
  }
}