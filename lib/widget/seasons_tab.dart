import 'package:flutter/material.dart';

class SeasonsTab extends StatelessWidget {
  SeasonsTab(this.seasonN);
  final seasonN;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: 5.0, right: 5.0),
        //                width:65,
        child: new Text(
          'Season $seasonN',
          style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.9,
              color: Colors.white),
        ),
    );
  }
}