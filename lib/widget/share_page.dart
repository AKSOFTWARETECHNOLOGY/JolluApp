import 'package:flutter/material.dart';
import 'package:share/share.dart';

// Share tab
class SharePage extends StatelessWidget {
  SharePage(this.shareType, this.shareId);
  final shareType;
  final shareId;

  Widget shareText(){
    return Text(
      "Share",
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

  Widget shareTabColumn(){
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.share,
          size: 30.0,
          color: Colors.white,
        ),
        new Padding(
          padding:
          const EdgeInsets.fromLTRB(
              0.0, 0.0, 0.0, 10.0),
        ),
        shareText(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Material(
          child:  new InkWell(
            onTap: () {
              Share.share('$shareType'+'$shareId');
            },
            child: shareTabColumn(),
          ),
          color: Colors.transparent,
        )
    );
  }
}