import 'package:flutter/material.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';
import 'package:http/http.dart' as http;
import 'package:next_hour/model/video_data.dart';
import 'package:next_hour/ui/deatiledViewPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ItemList extends StatefulWidget {
  ItemList({@required this.item, this.index});
  final VideoDataModel item;
  final index;

  @override
  State<StatefulWidget> createState() {
    return ItemListState();
  }
}

class ItemListState extends State<ItemList> {

//Handle watchlist item on dismiss or display watch list.
  Future <String> watchlistResponse() async {
  try {
    var testID = widget.item.id;

    if (widget.item.datatype == "T") {
      for (var j = 0; j < widget.item.seasons.length; j++) {
        for (var k = 0; k < userWatchList.length; k++) {
          if(userWatchList[k].season_id == widget.item.seasons[j].id){

            // ignore: unused_local_variable
            final response1 = await http.get(Uri.encodeFull(
                APIData.removeWatchlistSeason + "${widget.item.seasons[j].id}"),
                headers: {
                  // ignore: deprecated_member_use
                  HttpHeaders.AUTHORIZATION: fullData
                }
            );
            userWatchList.removeWhere((item) =>
                              item.season_id == widget.item.seasons[j].id);
          }else{
//            print('not avl');
          }
        }
      }
    }
    else {
      userWatchList.removeWhere((item) => item.wMovieId == testID);

      final checkResponseMovie = await http.get(
          Uri.encodeFull(APIData.checkWatchlistMovie + "$testID"),
          headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: fullData

          });
      var res2 = jsonDecode(checkResponseMovie.body);
      if (res2['wishlist'] == 1) {
        final response2 = await http.get(
            Uri.encodeFull(APIData.removeWatchlistMovie + "$testID"),
            headers: {
              // ignore: deprecated_member_use
              HttpHeaders.AUTHORIZATION: fullData
            });
        int statusCode2 = response2.statusCode;
        print(statusCode2);
        if (statusCode2 == 200) {
        }
      }
    }
    return null;
  }
  catch (e) {
//    print(e);
    return null;
  }
}

//Swipe left to remove from watchlist
  Widget swipeRightContainer(){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(FontAwesomeIcons.longArrowAltRight,  color: Colors.white60),
          SizedBox(
            width: 10.0,
          ),
          Text("Swipe right to remove", style: TextStyle(letterSpacing: 1.0, color: Colors.white60),),
        ],
      ),
      alignment: Alignment.centerRight,
    );
  }

//Swipe right to remove form watchlist
  Widget swipeLeftContainer(){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("Swipe left to remove", style: TextStyle(letterSpacing: 1.0, color: Colors.white60),),
          SizedBox(
            width: 10.0,
          ),
          Icon(FontAwesomeIcons.longArrowAltLeft,  color: Colors.white60),
        ],
      ),
      alignment: Alignment.centerRight,
    );
  }

// PlaceHolder image displayed on the watchlist item.
  Widget placeHolderImage(){
    return Expanded(
      flex: 1,
      child: Container(
        child: new ClipRRect(
          borderRadius:
          new BorderRadius.circular(8.0),
          child: new FadeInImage.assetNetwork(
            image:widget.item.box,
            //imageScale: 1.0,
            placeholder:
            "assets/placeholder_box.jpg",
            height: 140.0,
            // width: 220.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

//Details displayed on watchlist item
  Widget watchlistItemDetails(genres){
    return Expanded(
      flex:3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Text(
            widget.item.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 4.0),
          Text(
            '$genres',
            style: TextStyle(
                color: Color.fromRGBO(72, 163, 198, 1.0),
                fontSize: 12.0,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.left,
            maxLines: 1,
          ),
          SizedBox(height: 0.0),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'RELEASE DATE:',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      widget.item.released,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'RUNTIME:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      widget.item.duration == "Not Available"
                          ? widget.item.duration
                          : widget.item.duration + " min",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//  Watchlist item all details like image, name, 
  Widget watchlistItemContainer(genres){
    return Container(
      color: Colors.transparent,
      margin: new EdgeInsets.fromLTRB(
          0.0,8.0,0.0,8.0),
      child: InkWell(
        onTap: (){
          var router = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new DetailedViewPage(widget.item)
          );
          Navigator.of(context).push(router);
        },
        child: Container(

          decoration: new BoxDecoration(
            color: Color.fromRGBO(20, 20, 20, 1.0),
            shape: BoxShape.rectangle,
            borderRadius:
            new BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              placeHolderImage(),
              SizedBox(
                width: 10.0,
                height: 0.0,
              ),
              watchlistItemDetails(genres),
            ],
          ),
        ),
      ),
    );
  }

//  Dismiss watchlist item
  Widget dismiss(){
    String genres = widget.item.genres.toString();
    genres = genres.replaceAll("[", "").replaceAll("]", "");
    widget.item.genres.removeWhere((value) => value == null);
    return Dismissible(
      key: Key("${widget.item.id}"),
      confirmDismiss: (direction) async{
        if (direction == DismissDirection.startToEnd) {
          watchlistResponse();
          return true;
        } else if (direction == DismissDirection.endToStart) {
          watchlistResponse();
          return true;
        }
        return true;
      },
      crossAxisEndOffset: 0.0,
      background: swipeRightContainer(),
      secondaryBackground: swipeLeftContainer(),
      child: watchlistItemContainer(genres),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  dismiss();
  }
}
