import 'package:flutter/material.dart';
import 'package:next_hour/model/video_data.dart';

class VideoBoxItem extends StatelessWidget {
  static const IMAGE_RATIO = 1.50;

  VideoBoxItem(this.buildContext, this.game, {this.height = 120.0});
  final BuildContext buildContext;
  final VideoDataModel game;
  //final double width;
 final double height;

  @override
  Widget build(BuildContext context) {
return new Material(
    borderRadius:  new BorderRadius.circular(8.0),
    child:new ClipRRect(
      borderRadius: new BorderRadius.circular(8.0),
      child: new FadeInImage.assetNetwork(
        image: game.box,
        //imageScale: 1.0,
        placeholder: "assets/placeholder_box.jpg",
        height: 160.0,
        // width: 220.0,
        fit: BoxFit.cover,
      ),
    ),
    );
  }
}
