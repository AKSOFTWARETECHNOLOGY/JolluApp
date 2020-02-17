import 'package:flutter/material.dart';

import 'package:next_hour/model/video_data.dart';
import 'package:next_hour/ui/deatiledViewPage.dart';
import "package:next_hour/utils/item_video_box.dart";

class VideoContainerItem extends StatelessWidget {
  VideoContainerItem(this.buildContext, this.game);
  final BuildContext buildContext;
  final VideoDataModel game;

  @override
  Widget build(BuildContext context) {

    return new Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: new InkWell(
        onTap: () => _goGameDetailsPage(context, game),
        child: videoColumn(context),
      ),
    );
  }

  void _goGameDetailsPage(BuildContext context, VideoDataModel game) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new DetailedViewPage(game);
        },
      ),
    );
  }

  Widget videoColumn(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        new Hero(
          tag: game.name,
          child: new VideoBoxItem(context, game, height: 170.0,),
        ),
        new Padding(padding: const EdgeInsets.only(top: 6.0)),
        new ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              ],
            ))
      ],
    );
  }
}
