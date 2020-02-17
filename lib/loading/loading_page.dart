import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/ui/login_page.dart';
import 'package:next_hour/utils/color_loader.dart';
import 'package:next_hour/model/WatchlistModel.dart';
import 'package:next_hour/model/video_data.dart';
import 'package:next_hour/model/seasons.dart';
import 'package:next_hour/controller/navigation_bar_controller.dart';
import 'package:path_provider/path_provider.dart';

File jsonFile;
Directory dir;
String fileName = "userJSON.json";
bool fileExists = false;
Map<dynamic, dynamic> fileContent;

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key, this.isSelected, this.useremail, this.userpass}) : super(key: key);
  final bool isSelected;
  final String useremail;
  final String userpass;

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with TickerProviderStateMixin{
  Animation<double> containerGrowAnimation;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.blue
  ];

  bool _visible = false;
  bool _visible3 = false;
  @override

  void initState() {

    super.initState();

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        this.setState(
                () => fileContent = json.decode(jsonFile.readAsStringSync()));
      }
    });

    Timer(Duration(seconds: 1), (){
      setState(() {
        _visible = true;
      });

    });
    Timer(Duration(seconds: 2), (){
      _login();
    });

    Timer(Duration(seconds: 5), (){
      setState(() {
        _visible3 = true;
      });
    });

  }

  void loginError(){
    var router = new MaterialPageRoute(
        builder: (BuildContext context) => new LoginPage());
    Navigator.of(context).push(router);
    Fluttertoast.showToast(msg: "The user credentias were incorrect..!");
  }


  void noNetwork() {
    var router = new MaterialPageRoute(
        builder: (BuildContext context) => new LoginPage());
    Navigator.of(context).push(router);
    Fluttertoast.showToast(msg: "Please Check Network Connection!");

  }

  Future<String> _login() async {
    try {
      final accessToken = await http.post(APIData.tokenApi, body: {
        "email": widget.useremail,
        "password": widget.userpass,
      });
      print(accessToken.statusCode);
      var user = json.decode(accessToken.body);
      if (accessToken.statusCode == 200) {
        final response = await http.get(APIData.userProfileApi,
            // ignore: deprecated_member_use
            headers: {
              // ignore: deprecated_member_use
              HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
            });

        setState(() {
          fullData = "Bearer ${user['access_token']}!";
        });

        final menuResponse = await http.get(
            Uri.encodeFull(APIData.topMenu),
            headers: {
              // ignore: deprecated_member_use
              HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
              // ignore: deprecated_member_use
            });
        topMData = json.decode(menuResponse.body);

        final showWatchlistResponse =
        await http.get(Uri.encodeFull(APIData.watchListApi),
            headers: {
              // ignore: deprecated_member_use
              HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
            });
        var showWatchlistData= json.decode(showWatchlistResponse.body);

        showWatchlist = showWatchlistData['wishlist'];

        final compData = await http.get(
            Uri.encodeFull(APIData.movieTvApi),
            headers: {
              // ignore: deprecated_member_use
              HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
            }
            );

        final stripeDetailsResponse =
        await http.get(Uri.encodeFull(APIData.stripeDetailApi), headers: {
          // ignore: deprecated_member_use
          HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
        });
        stripeData=json.decode(stripeDetailsResponse.body);
        stripeKey = stripeData['key'];
        stripePass = stripeData['pass'];
        payStackKey = stripeData['paystack'];


        var aData = json.decode(compData.body);
        List aData2 = aData['data'];

        final mainResponse2 =
        await http.get(Uri.encodeFull(APIData.allDataApi), headers: {
          // ignore: deprecated_member_use
          HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
        }
        );

          final userProfileApiResponse =
          await http.get(Uri.encodeFull(
                  APIData.userProfileApi), headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: fullData
                // ignore: deprecated_member_use
              });

        userProfileApiData = json.decode(userProfileApiResponse.body);
        status=userProfileApiData['active'];
        userPlanStart=userProfileApiData['start'] != null ? DateTime.parse(userProfileApiData['start']) : 'N/A';
        userPlanEnd= userProfileApiData['end']!=null? DateTime.parse(userProfileApiData['end']): 'N/A';
        currentDate= userProfileApiData['current_date']!=null? DateTime.parse(userProfileApiData['current_date']) : 'N/A';

        final faqApiResponse = await http.get(
          Uri.encodeFull(APIData.faq),
        );
        faqApiData=json.decode(faqApiResponse.body);
        faqHelp=faqApiData['faqs'];

          var mainData2 = json.decode(mainResponse2.body);
        var genreData2 = mainData2['genre'];

        int dataLen = aData2.length == null ? 0 : aData2.length;

        searchIds2.clear();

        if (dataLen != null) {

          for (var all = 0; all < dataLen; all++) {
                searchIds2.add(aData2[all]);
          }
        }
        var singleId;
        userWatchListOld = List<VideoDataModel>.generate(
            searchIds2 == null ? 0 : dataLen, (int index) {
          var type = searchIds2[index]['type'];

          var description =
          searchIds2[index]['detail'];

          var t = description;

          var genreIdbyM = searchIds2[index]['genre_id'];

          singleId = genreIdbyM.split(",");

          var tmdbrating = searchIds2[index]['rating'];

          double convrInStart = tmdbrating / 2;

          List<dynamic> se2;
          if(type == "T"){
            se2 = searchIds2[index]['seasons'] as List<dynamic>;
          }else{
            se2 = searchIds2[index]['movie_series'] as List<dynamic>;
          }

          return new VideoDataModel(
            id:searchIds2[index]['id'],
            name: '${searchIds2[index]['title']}',
            box: type == "T"
                ? "${APIData.tvImageUriTv}" +
                "${searchIds2[index]['thumbnail']}"
                : "${APIData.movieImageUri}" +
                "${searchIds2[index]['thumbnail']}",
            cover: type == "T"
                ? "${APIData.tvImageUriPosterTv}" +
                "${searchIds2[index]['poster']}"
                : "${APIData.movieImageUriPosterMovie}" +
                "${searchIds2[index]['poster']}",
            description: '$t',
            datatype: type,
            rating: convrInStart,
            screenshots: List.generate(3, (int xyz) {
              return type == "T"
                  ? "${APIData.tvImageUriPosterTv}" +
                  "${searchIds2[index]['poster']}"
                  : "${APIData.movieImageUriPosterMovie}" +
                  "${searchIds2[index]['poster']}";
            }),
            url: '${searchIds2[index]['trailer_url']}',
            menuId: 1,
            genre: List.generate(
                singleId == null ? 0 : singleId.length,
                    (int xyz) {
                  return "${singleId[xyz]}";
                }),
            genres: List.generate(
                genreData2 == null ? 0 : genreData2.length, (int xyz) {
              var genreId2 = genreData2[xyz]['id'].toString();
              var zx = List.generate(
                  singleId == null ? 0 : singleId.length,(int xyz) {
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
                if( genreData2[xyz]['name'] == null){
                  return null;
                }else{
                  return "${genreData2[xyz]['name']}";
                }
              }
              return null;
            }),
            seasons: List<Seasons>.generate(se2== null ? 0 : se2.length, (int s){
              if(type == "T"){
                return new Seasons(
                  id: se2[s]['id'],
                  sTvSeriesId: se2[s]['tv_series_id'],
                  sSeasonNo: se2[s]['season_no'],
                  thumbnail: se2[s]['thumbnail'],
                  cover: se2[s]['poster'],
                  description: se2[s]['detail'],
                  sActorId: se2[s]['actor_id'],
                  language: se2[s]['a_language'],
                  type: se2[s]['type'],
                );
              }else{
                return null;
              }
            }),
            maturityRating:
            '${searchIds2[index]['maturity_rating']}',
            duration: type == "T" ? 'Not Available': '${searchIds2[index]['duration']}',
            released: type == "T" ? 'Not Available': '${searchIds2[index]['released']}',
          );
        }
        );

        userWatchList = List<WatchlistModel>.generate(showWatchlist == null ? 0 : showWatchlist.length, (int index){

          return new WatchlistModel(
            id: showWatchlist[index]['id'],
            wUserId:showWatchlist[index]['user_id'],
            wMovieId: showWatchlist[index]['movie_id'],
            season_id: showWatchlist[index]['season_id'],

            added: showWatchlist[index]['added'],
            wCreatedAt: '${showWatchlist[index]['created_at']}',
            wUpdatedAt: '${showWatchlist[index]['updated_at']}',
          );
        }
        );

        final sliderResponse = await http.get(Uri.encodeFull(APIData.sliderApi), headers: {
          // ignore: deprecated_member_use
          HttpHeaders.AUTHORIZATION: fullData

        });
        sliderResponseData = json.decode(sliderResponse.body);

        sliderData = sliderResponseData['slider'];

        dataUser = json.decode(response.body);

        setState(() {
          userDetail = dataUser['user'];
          userRole = userDetail['is_admin'];
          userImage = userDetail['image'];
          userName = userDetail['name'];
          userEmail = userDetail['email'];
          userMobile = userDetail['mobile'];
          userDOB = userDetail['dob'];
          userCreatedAt = userDetail['created_at'];
          stripeCustomerId = userDetail['stripe_id'];
          activePlan = dataUser['current_subscription'];
          userPaypalHistory = dataUser['paypal'];
          userStripeHistory = userDetail['subscriptions'];
          userActivePlan = dataUser['current_subscription'];
          userPaypalPayId = dataUser['payid'] !=null ? dataUser['payid']: '';
          userExpiryDate = dataUser['end'];
          status=dataUser['active'];
          userPlanStart=dataUser['start'] != null ? DateTime.parse(dataUser['start']) : 'N/A';
          userPlanEnd= dataUser['end']!= null? DateTime.parse(dataUser['end']): 'N/A';
          currentDate= dataUser['current_date']!=null? DateTime.parse(dataUser['current_date']) : 'N/A';
          faqHelp=faqApiData['faqs'];

          showPaymentGateway = homeApiResponseData['config'];

          stripePayment=showPaymentGateway['stripe_payment'];
          btreePayment=showPaymentGateway['btree_payment'];
          paystackPayment=showPaymentGateway['paystack'];

        });

        setState(() {
          showWatchlist = showWatchlistData['wishlist'];
          userId = userDetail['id'];
          code = dataUser['code'];
          topMenuData = topMData['menu'];
          menuList = topMenuData.length;
          name = userName;
          email = userEmail;
          expiryDate = userExpiryDate;
          nameInitial = userName[0];
          if (userRole == 1) {
            role = "Admin";
          } else {
            role = "User";
          }
          if (userMobile == null) {
            mobile = "N/A";
          } else {
            mobile = userMobile;
          }
          if (userDOB == null) {
            dob = 'N/A';
          } else {
            dob = userDOB;
          }
          if (userCreatedAt == null) {
            created_at = "";
          } else {
            created_at = userCreatedAt;
          }
          if (userActivePlan == null) {
            activePlan = "N/A";
          } else {
            activePlan = userActivePlan;
          }
          if (userExpiryDate == null) {
            expiryDate = '';
          } else {
            expiryDate = userExpiryDate;
          }

        });
        var router = new MaterialPageRoute(
            builder: (BuildContext context) => new BottomNavigationBarController()
        );
        Navigator.of(context).push(router);
        setState(() {
          message = "welcome admin";
        });



        if(widget.isSelected == true){
          writeToFile("user", widget.useremail);
          writeToFile("pass", widget.userpass);
        }
      } else {
        loginError();
      }

      return null;
    }
    catch (e) {
      print(e);
      noNetwork();
      return null;
    }
  }

  void createFile(Map<String, String> content, Directory dir, String fileName) {
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    setState(() {
      fileExists = true;
    });
    file.writeAsStringSync(json.encode(content));
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
  }

  void writeToFile(String key, String value) {
    Map<String, String> content = {key: value};
    if (fileExists) {
      Map<dynamic, dynamic> jsonFileContent =
      json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      createFile(content, dir, fileName);
    }

    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
  }

  Widget loadingPageWidget(){
      return  Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                animatedOpacityLogo(),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                animatedOpacityCircular(),
              ],
            ),
          )
      );
  }

  Widget animatedOpacityLogo(){
      return AnimatedOpacity(
        opacity: _visible == true ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        // The green box must be a child of the AnimatedOpacity widget.
        child: homeApiResponseData == null ? new Image.asset('assets/logo.png', scale: 0.9,) : new Image.network(
          '${APIData.logoImageUri}${loginConfigData['logo']}',
          scale: 0.9,
        ),
      );
  }

  Widget animatedOpacityCircular(){
    return AnimatedOpacity(
      // If the widget is visible, animate to 0.0 (invisible).
      // If the widget is hidden, animate to 1.0 (fully visible).
      opacity: _visible == true ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      // The green box must be a child of the AnimatedOpacity widget.
      child: _visible3 == true ?
      ColorLoader():ColorLoader(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(34, 34, 34, 1.0),)

          ),
          Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              loadingPageWidget(),

            ],)
        ],
      ),
    );
  }

}

