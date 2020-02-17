import 'package:flutter/material.dart';
import 'package:next_hour/component/item_genre_container.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/model/video_data.dart';

var itemLen;

class HorizontalGenreController extends StatelessWidget {
  HorizontalGenreController(this.dataItems);

  final List<VideoDataModel> dataItems;
  Widget listView(){
    return ListView.builder(
        itemCount: itemLen == 0 ? 0 : itemLen,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16.0, top: 4.0),
        itemBuilder: (BuildContext context, int position) {
          var isAv = 0;
          for (var x in dataItems[position].genre) {
            if (genreId == x) {
              isAv = 1;
              break;
            }
          }
          if (isAv == 1) {
            return GenreContainerItem(context, dataItems[position]);
          } else {
            return new Padding(
              padding: const EdgeInsets.only(right: 0.0),
            );
          }
        });
  }
  @override
  Widget build(BuildContext context) {
    try {
      var getDataLength = 0;
      if (dataItems == null) {
        itemLen = getDataLength;
      } else {
        itemLen = dataItems.length;
      }
    } catch (e) {
      print(e);
    }

    return new SizedBox.fromSize(
      size: const Size.fromHeight(170.0),
      child: listView(),
    );
  }
}
