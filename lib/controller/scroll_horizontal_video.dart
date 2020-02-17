import 'package:flutter/material.dart';
import 'package:next_hour/component/item_video_container.dart';
import 'package:next_hour/model/video_data.dart';

var itemLen;

class HorizontalVideoController extends StatelessWidget {
  HorizontalVideoController(this.dataItems);

  final List<VideoDataModel> dataItems;

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
      child: new ListView.builder(
          itemCount: itemLen == 0 ? 0 : itemLen,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16.0, top: 4.0),
          itemBuilder: (BuildContext context, int position) {
            return VideoContainerItem(context, dataItems[position]);
          }),
    );
  }

}
