import 'package:flutter/material.dart';
import 'package:next_hour/global.dart';

class WishListContainer extends StatelessWidget {
  WishListContainer(this.isAdded);
  final isAdded;
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: <Widget>[
        isAdded == 1? Icon(Icons.check, size: 30.0, color: greenPrime,): Icon(Icons.add, size: 30.0, color: Colors.white,),

        new Padding(
          padding:
          const EdgeInsets.fromLTRB(
              0.0, 0.0, 0.0, 10.0),
        ),
        new Text(
          "My List",
          style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
              color: Colors.white
            // color: Colors.white
          ),
        ),
      ],
    );
  }
}