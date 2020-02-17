import 'package:flutter/material.dart';
import 'package:next_hour/model/video_data.dart';
import "package:next_hour/utils/item_video_box.dart";
import "package:next_hour/ui/page_video_details.dart";

class GenreContainerItem extends StatelessWidget {
  GenreContainerItem(this.buildContext, this.game);
  final BuildContext buildContext;
  final VideoDataModel game;

  @override
  Widget build(BuildContext context) {

    return new Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: new InkWell(
        onTap: () => _goGameDetailsPage(context, game),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            new Container(
//              tag: game.name,
              height: 160.0,
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
        ),
      ),
    );
  }

  void _goGameDetailsPage(BuildContext context, VideoDataModel game) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new VideoGenreDetailsPage(game);
        },
      ),
    );
  }
}
