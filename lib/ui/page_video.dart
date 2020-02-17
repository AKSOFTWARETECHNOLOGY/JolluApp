import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/controller/scroll_horizontal_video.dart';
import 'package:next_hour/controller/scroll_horizontal_genre.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/model/video_data.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:next_hour/model/seasons.dart';
import 'package:next_hour/ui/no_network.dart';
import 'package:next_hour/widget/image_slider.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';


class VideosPage extends StatefulWidget {
  VideosPage({Key key, this.mId}) : super(key: key);
  final mId;

  @override
  _VideosPageState createState() => new _VideosPageState();
}

class _VideosPageState extends State<VideosPage> with SingleTickerProviderStateMixin, RouteAware {

  GlobalKey _keyRed = GlobalKey();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  ScrollController controller;
  HorizontalVideoController moviecontroller;
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {

    menuDataArray = null;
    this.getMenuData();

    super.initState();
    this.refreshList();

    controller = ScrollController(initialScrollOffset: 50.0);

//    This will check your connection status
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(_connectionStatus);
          checkConnectionStatus = result.toString();
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
          }
          else {
            var router = new MaterialPageRoute(
                builder: (BuildContext context) => new NoNetwork());
            Navigator.of(context).push(router);
          }
        });
  }

//  Used to refresh the list of movies and TV series on the home page
  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    getMenuData();
  }

//  This future will return all the data related to particular menu.
  Future<String> getMenuData() async {
    try {
      final menuData = await http.get(
          Uri.encodeFull(APIData.menuDataApi + "/${widget.mId}"),
          headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: fullData
          });

      final mainResponse =
      await http.get(Uri.encodeFull(APIData.allDataApi), headers: {
        // ignore: deprecated_member_use
        HttpHeaders.AUTHORIZATION: fullData
      }
      );

      mainData = json.decode(mainResponse.body);

      menuDataResponse = json.decode(menuData.body);
      menuDataArray = menuDataResponse['data'];

      menuDataListLength = menuDataArray.length == null ? 0 : menuDataArray.length;
      searchIds.clear();
      if (menuDataListLength != null) {
        for (var all = 0; all < menuDataListLength; all++) {
          for (var f in menuDataArray[all]) {
            searchIds.add(f);
          }
        }
      }

      menuDataResponse = json.decode(menuData.body);
      menuDataArray = menuDataResponse["data"];

      if (mounted) {
        this.setState(() {
          genreData = mainData['genre'];
        });
      }
    } on SocketException catch (_) {
      var router = new MaterialPageRoute(
          builder: (BuildContext context) => new NoNetwork());
      Navigator.of(context).push(router);
      print('not connected');
    }

    return null;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

//  Heading text shimmer
  Widget headingTextShimmer(){
    return Container(
      child: new Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 5.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Container(
              child: new Container(
                child: new ClipRRect(
                  borderRadius:
                  new BorderRadius.circular(8.0),
                  child: new SizedBox(
                    child: Shimmer
                        .fromColors(
                      baseColor: Color.fromRGBO(45, 45, 45, 1.0),
                      highlightColor:
                      Color.fromRGBO(50, 50, 50, 1.0),
                      child: Card(
                        elevation: 0.0, color: Color.fromRGBO(45, 45, 45, 1.0),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10),),
                        ),
                        clipBehavior:
                        Clip.antiAliasWithSaveLayer,
                        child:
                        SizedBox(
                          width: 220,
                          height: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//  Slider image shimmer
  Widget sliderImageShimmer(width){
    return Padding(
      padding: const EdgeInsets.only(
          left:15.0,right: 15.0),
      child: new InkWell(
        onTap: () {},
        child: new Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .center,
          children: [
            new Container(
              child: new Container(
                child: new ClipRRect(
                  borderRadius:
                  new BorderRadius.circular(0.0),
                  child: new SizedBox(
                    child: Shimmer
                        .fromColors(
                      baseColor: Color.fromRGBO(45, 45, 45, 1.0),
                      highlightColor: Color.fromRGBO(50, 50, 50, 1.0),
                      child: Card(
                        elevation: 0.0,
                        color: Color.fromRGBO(45, 45, 45, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .all(
                            Radius.circular(
                                10),
                          ),
                        ),
                        clipBehavior:
                        Clip.antiAliasWithSaveLayer,
                        child:
                        SizedBox(
                          width: width,
                          height: 180,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// images shimmer
  Widget videoImageShimmer(width){
    return SizedBox.fromSize(
        size: const Size.fromHeight(180.0),
        child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
                left: 16.0, top: 4.0),
            itemBuilder: (BuildContext context,
                int position) {
              return new Padding(
                padding: const EdgeInsets.only(
                    right: 12.0),
                child: new InkWell(
                  onTap: () {},
                  child: new Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .center,
                    children: [
                      new Container(
                        child: new Container(
                          child: new ClipRRect(
                            borderRadius:
                            new BorderRadius.circular(8.0),
                            child: new SizedBox(
                              child: Shimmer.fromColors(
                                baseColor: Color.fromRGBO(45, 45, 45, 1.0),
                                highlightColor: Color.fromRGBO(50, 50, 50, 1.0),
                                child: Card(
                                  elevation: 0.0,
                                  color: Color.fromRGBO(45, 45, 45, 1.0),
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(
                                      Radius.circular(
                                          10),
                                    ),
                                  ),
                                  clipBehavior:
                                  Clip.antiAliasWithSaveLayer,
                                  child:
                                  SizedBox(
                                    width: 100,
                                    height: 160,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

// shimmer
  Widget shimmer(width){
    return SingleChildScrollView(
        child: new Column(
            key: _keyRed,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//                  Image slider shimmer
              sliderImageShimmer(width),

              new Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
                  child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      physics: ClampingScrollPhysics(),
                      primary: true,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(top: 0.0),
                      itemBuilder: (BuildContext context, int index) {
                        return new Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0,
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0),
                            child: new Column(children: <Widget>[
//                                  Heading text shimmer
                              headingTextShimmer(),
//                                  All data images shimmer
                              videoImageShimmer(width),
                            ]));
                      }))
            ]));
  }

// List tv series and movies
  Widget tvSeriesAndMoviesList(){
    return Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: menuDataListLength == null ? 0 : menuDataListLength,
            physics: ClampingScrollPhysics(),
            primary: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(top: 0.0),
            itemBuilder: (BuildContext context, int index1) {
              var type;
              var description;
              var t;

              var singleId;

              newVideosList1 = List<VideoDataModel>.generate(

                  menuDataArray[index1].length == null
                      ? 0
                      : menuDataArray[index1].length, (int index) {

                List data1 = menuDataArray[index1];
                type = data1[index]['type'];
                description = data1[index]['detail'];
                t = description;
                var genreIdbyM = data1[index]['genre_id'];
                singleId = genreIdbyM.split(",");

                var tmdbrating = data1[index]['rating'];
                double convrInStart = tmdbrating / 2;
                List<dynamic> se;
                if(type == "T"){
                  se = data1[index]['seasons'] as List<dynamic>;
                }else{
                  se = data1[index]['movie_series'] as List<dynamic>;
                }

                return new VideoDataModel(
                    id: data1[index]['id'],
                    name: '${data1[index]['title']}',
                    box: type == "T"
                        ? "${APIData.tvImageUriTv}" +
                        "${data1[index]['thumbnail']}"
                        : "${APIData.movieImageUri}" +
                        "${data1[index]['thumbnail']}",
                    cover: type == "T"
                        ? "${APIData.tvImageUriPosterTv}" +
                        "${data1[index]['poster']}"
                        : "${APIData.movieImageUriPosterMovie}" +
                        "${data1[index]['poster']}",
                    description: "$t",
                    datatype: type,
                    rating: convrInStart,
                    screenshots: List.generate(3, (int xyz) {
                      return type == "T"
                          ? "${APIData.tvImageUriPosterTv}" +
                          "${data1[index]['poster']}"
                          : "${APIData.movieImageUriPosterMovie}" +
                          "${data1[index]['poster']}";
                    }),
                    url: '${data1[index]['trailer_url']}',
                    menuId: 1,
                    genre: List.generate(
                        singleId == null ? 0 : singleId.length,
                            (int xyz) {
                          return "${singleId[xyz]}";
                        }),
                    genres: List.generate(
                        genreData == null ? 0 : genreData.length,
                            (int genereIndex) {
                          var genreId2 = genreData[genereIndex]['id'].toString();
                          var genrelist = List.generate(
                              singleId == null ? 0 : singleId.length,
                                  (int i) {
                                return "${singleId[i]}";
                              });
                          var isAv2 = 0;
                          for (var y in genrelist) {
                            if (genreId2 == y) {
                              isAv2 = 1;
                              break;
                            }
                          }
                          if (isAv2 == 1) {
                            if( genreData[genereIndex]['name'] == null){
                            }else{
                              return "${genreData[genereIndex]['name']}";
                            }
                          }
                          return null;
                        }),

                    seasons: List<Seasons>.generate(se== null ? 0 : se.length, (int seasonIndex){
                      if(type == "T"){
                        return new Seasons(
                          id: se[seasonIndex]['id'],
                          sTvSeriesId: se[seasonIndex]['tv_series_id'],
                          sSeasonNo: se[seasonIndex]['season_no'],
                          thumbnail: se[seasonIndex]['thumbnail'],
                          cover: se[seasonIndex]['poster'],
                          description: se[seasonIndex]['detail'],
                          sActorId: se[seasonIndex]['actor_id'],
                          language: se[seasonIndex]['a_language'],
                          type: se[seasonIndex]['type'],
                        );
                      }else{
                        return null;
                      }
                    }),
                    maturityRating:
                    '${data1[index]['maturity_rating']}'
                );
              }
              );

              allDataList.add(newVideosList1);
              return new Padding(
                padding: const EdgeInsets.only(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0),
                child: new Column(
                  children: <Widget>[
                    videoTypeContainer(type),
                    Container(
                        child: new HorizontalVideoController(
                            newVideosList1)
                    ),
                  ],
                ),
              );
            })
    );
  }

// List all genres
  Widget allGenresList(){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: genreData == null ? 0 : genreData.length,
        physics: ClampingScrollPhysics(),
        primary: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 0.0),
        itemBuilder: (BuildContext context, int index1) {
          var genreName = "${genreData[index1]['name']}";

          genreId = genreData[index1]['id'].toString();

          var singleId;
          int sum = 0;
          for (var e = 0; e < menuDataListLength; e++) {
            var m2 = menuDataArray[e].length;
            sum += m2;
          }


          var gTest = List.generate(
              genreData == null ? 0 : genreData.length,
                  (int xyz) {
                var genreId2 = genreData[xyz]['id'].toString();
                var zx = List.generate(
                    singleId == null ? 0 : singleId.length,
                        (int xyz) {
                      return "${singleId[xyz]}";
                    });
                var isAv2 = 0;
                for (var y in zx) {
                  if (genreId2 == y) {
                    isAv2 = 1;
                    break;
                  }
                }
                if (isAv2 == 1) {
                  if( genreData[xyz]['name'] == null){
                  }
                  else{
                    return "${genreData[xyz]['name']}";
                  }
                }
                return null;
              }
          );

          gTest.removeWhere((value) => value == null);
          newVideosListG = List<VideoDataModel>.generate(
              searchIds == null ? 0 : sum, (int index) {
            var type = searchIds[index]['type'];
            var description =
            searchIds[index]['detail'];
            var t = description;
            var genreIdbyM = searchIds[index]['genre_id'];
            singleId = genreIdbyM.split(",");
            var tmdbrating = searchIds[index]['rating'];
            double convrInStart = tmdbrating / 2;
            List<dynamic> se;
            if(type == "T"){
              se = searchIds[index]['seasons'] as List<dynamic>;
            }else{
              se = searchIds[index]['movie_series'] as List<dynamic>;
            }
            return new VideoDataModel(
              id:searchIds[index]['id'],
              name: '${searchIds[index]['title']}',
              box: type == "T"
                  ? "${APIData.tvImageUriTv}" +
                  "${searchIds[index]['thumbnail']}"
                  : "${APIData.movieImageUri}" +
                  "${searchIds[index]['thumbnail']}",
              cover: type == "T"
                  ? "${APIData.tvImageUriPosterTv}" +
                  "${searchIds[index]['poster']}"
                  : "${APIData.movieImageUriPosterMovie}" +
                  "${searchIds[index]['poster']}",
              description: '$t',
              datatype: type,
              rating: convrInStart,
              screenshots: List.generate(3, (int xyz) {
                return type == "T"
                    ? "${APIData.tvImageUriPosterTv}" +
                    "${searchIds[index]['poster']}"
                    : "${APIData.movieImageUriPosterMovie}" +
                    "${searchIds[index]['poster']}";
              }),
              url: '${searchIds[index]['trailer_url']}',
              menuId: 1,
              genre: List.generate(
                  singleId == null ? 0 : singleId.length,
                      (int xyz) {
                    return "${singleId[xyz]}";
                  }),
              genres: List.generate(
                  genreData == null ? 0 : genreData.length,
                      (int xyz) {
                    var genreId2 = genreData[xyz]['id'].toString();
                    var zx = List.generate(
                        singleId == null ? 0 : singleId.length,
                            (int xyz) {
                          return "${singleId[xyz]}";
                        });
                    var isAv2 = 0;
                    for (var y in zx) {
                      if (genreId2 == y) {
                        isAv2 = 1;
                        break;
                      }
                    }
                    if (isAv2 == 1) {
                      if( genreData[xyz]['name'] == null){

                      }else{
                        return "${genreData[xyz]['name']}";
                      }

                    }
                    return null;

                  }),

              seasons: List<Seasons>.generate(se== null ? 0 : se.length, (int s){
                if(type == "T"){
                  return new Seasons(
                    id: se[s]['id'],
                    sTvSeriesId: se[s]['tv_series_id'],
                    sSeasonNo: se[s]['season_no'],
                    thumbnail: se[s]['thumbnail'],
                    cover: se[s]['poster'],
                    description: se[s]['detail'],
                    sActorId: se[s]['actor_id'],
                    language: se[s]['a_language'],
                    type: se[s]['type'],

                  );
                }else{
                  return null;
                }
              }),

              maturityRating:
              '${searchIds[index]['maturity_rating']}',
              duration: type == "T" ? 'Not Available': '${searchIds[index]['duration']}',
              released: type == "T" ? 'Not Available': '${searchIds[index]['released']}',
            );
            //   newGamesList.add(test);
          });
          var isAv = 0;
          for (var y in newVideosListG) {
            for (var x in y.genre) {
              if (genreId == x) {
                isAv = 1;
                break;
              }
            }
          }

          if (isAv == 1) {
            return new Padding(
              padding: const EdgeInsets.only(
                  top: 0.0,
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16.0, 12.0, 8.0, 5.0),
                      child: new Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            new Text(
                              "$genreName",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16.0,
                                  fontWeight:
                                  FontWeight.w800,
                                  letterSpacing: 0.9,
                                  color: Colors.white),
                            ),
                          ]),
                    ),
                  ),
                  new Container(
                      child: new HorizontalGenreController(
                          newVideosListG)
                  ),
                ],
              ),
            );
          } else {
            return new Padding(
              padding: const EdgeInsets.only(right: 0.0),
            );
          }
        }
    );
  }

// tv series and movies column
  Widget tvAndMoviesColumn(){
    return SingleChildScrollView(
        child: Column(
          key: _keyRed,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageSliderContainer(),

//              TV And Movie
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
              child: tvSeriesAndMoviesList(),
            ),

//             For All Genre
            Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
              child: allGenresList(),
            ),
          ],
        )
    );
  }

// slider image container
  Widget imageSliderContainer(){
    return Stack(
        children: <Widget>[
          Container(
            child: sliderData.length == 0 ?
            SizedBox.shrink()
                : ImageSlider(),
          ),
        ]);
  }
// Type Text
  Widget typeText(type){
    return Text(
      "${type == "T" ? "TV Series" : "Movies"}",
      style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.9,
          color: Colors.white),
    );
  }

// Video type
  Widget videoTypeContainer(type){
    return Container(
      child: new Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 12.0, 8.0, 5.0),
        child: new Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              typeText(type),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return new Container(
      child: RefreshIndicator(
        key: refreshKey,
        child:
        menuDataListLength == 0 || menuDataArray == null ?
//      For Shimmer
          shimmer(width) :
        tvAndMoviesColumn(),
        onRefresh: refreshList,
      ),
      color: Color.fromRGBO(34, 34, 34, 1.0),
    );
  }
}






