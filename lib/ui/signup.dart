import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/ui/intro_slider.dart';
import 'package:next_hour/model/WatchlistModel.dart';
import 'package:next_hour/model/video_data.dart';
import 'package:next_hour/model/seasons.dart';
import 'package:next_hour/controller/navigation_bar_controller.dart';
import 'package:next_hour/widget/confirm_password_field.dart';
import 'package:next_hour/widget/email_field.dart';
import 'package:next_hour/widget/name_field.dart';
import 'package:next_hour/widget/password_field.dart';
import 'package:next_hour/widget/radio_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:next_hour/utils/wavy_header_image.dart';
import 'package:sticky_headers/sticky_headers.dart';


File jsonFile;
Directory dir;
String fileName = "userJSON.json";
bool fileExists = false;
bool _isSelected = false;
Map<dynamic, dynamic> fileContent;
var acct;
bool _isButtonDisabled;
class SignUpForm extends StatefulWidget {
  final String name;

  SignUpForm({Key key, this.name}) : super(key: key);

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> with TickerProviderStateMixin{
  String pass;
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _repeatPasswordController = new TextEditingController();
  String msg = '';
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

// Radio button to remember password
  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

// Sign up button
  void _signUp() {
    final form = formKey.currentState;
    form.save();
    if (form.validate() == true) {
      profileLoad();
      Timer(Duration(seconds: 2), (){
        registration();
      });
    }
  }

// Registration
  Future<String> registration() async{
    try{
      var url=APIData.registerApi;
      final register= await http.post(url, body: {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      });
      if(register.statusCode == 200){
        print(register.statusCode);
        if(_isSelected == true){
          writeToFile("user", _emailController.text);
          writeToFile("pass", _passwordController.text);
        }
        loginFromFIle();
        setState(() {
          _isButtonDisabled = true;
        });
      }else{
        if(register.statusCode == 302){
          registrationError();
          print(register.statusCode);
        }else{
          wentWrong();
          print(register.statusCode);
        }
      }
      return null;
    }catch(e){
      noNetwork();
      return null;
    }
  }

// Registration error
  void registrationError() {
    final snackBar = new SnackBar(
      content: new Text("Already Exists"),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

// Registration error
  void wentWrong() {
    final snackBar = new SnackBar(
      content: new Text("Error in Registration"),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

// Loading profile
  void profileLoad() {
    final snackBar = new SnackBar(
      content: new Text("Please Wait..."),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

// Network error
  void noNetwork() {
    final snackBar = new SnackBar(
      content: new Text("Please Check Network Connection!"),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
// Login from file
  Future<String> loginFromFIle() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (fileExists) {
          final accessToken = await http.post(APIData.tokenApi, body: {
            "email": fileContent['user'], "password": fileContent['pass'],
          });
          var user = json.decode(accessToken.body);
          final response = await http.get(APIData.userProfileApi,
              // ignore: deprecated_member_use
              headers: {
                // ignore: deprecated_member_use
                HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
              });

          final menuResponse = await http.get(
              Uri.encodeFull(APIData.topMenu),
              headers: {
                // ignore: deprecated_member_use
                HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
              });
          topMData = json.decode(menuResponse.body);

          final movieResponse2 = await http.get(
              Uri.encodeFull(APIData.allMovies),
              headers: {
                // ignore: deprecated_member_use
                HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
              });
          var mDataC = json.decode(movieResponse2.body);
          final sliderResponse =
          await http.get(Uri.encodeFull(APIData.sliderApi),
              headers: {
                // ignore: deprecated_member_use
                HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
              });

          final showWatchlistResponse =
          await http.get(Uri.encodeFull(APIData.watchListApi),
              headers: {
                // ignore: deprecated_member_use
                HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
              });
          var showWatchlistData= json.decode(showWatchlistResponse.body);

          sliderResponseData = json.decode(sliderResponse.body);
          sliderData = sliderResponseData['slider'];

          final basicDetails = await http.get(Uri.encodeFull(APIData.homeDataApi),);
          homeApiResponseData = json.decode(basicDetails.body);

          showWatchlist = showWatchlistData['wishlist'];

          showPaymentGateway = homeApiResponseData['config'];
          stripePayment=showPaymentGateway['stripe_payment'];
          btreePayment=showPaymentGateway['btree_payment'];
          paystackPayment=showPaymentGateway['paystack'];


          final compData = await http.get(
              Uri.encodeFull(APIData.menuDataApi + "/1"),
              headers: {
                // ignore: deprecated_member_use
                HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
              });
          var aData = json.decode(compData.body);
          List aData2 = aData['data'];


          final mainResponse2 =
          await http.get(Uri.encodeFull(APIData.allDataApi), headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: "Bearer ${user['access_token']}!"
          }
          );
          var mainData2 = json.decode(mainResponse2.body);
          var genreData2 = mainData2['genre'];

          int dataLen = aData2.length == null ? 0 : aData2.length;
          searchIds2.clear();
          if (dataLen != null) {
            for (var all = 0; all < dataLen; all++) {
              for (var f in aData2[all]) {
                searchIds2.add(f);
              }
            }
          }

          int sum = 0;
          for (var e = 0; e < dataLen; e++) {
            var m2 = aData2[e].length;
            sum += m2;
          }

          var singleId;
          userWatchListOld = List<VideoDataModel>.generate(
              searchIds2 == null ? 0 : sum, (int index) {

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
              screenshots: List.generate(3, (int seriesIndex) {
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
                      (int genreIndex) {
                    return "${singleId[genreIndex]}";
                  }),
              genres: List.generate(
                  genreData2 == null ? 0 : genreData2.length, (int genresIndex) {
                var genreId2 = genreData2[genresIndex]['id'].toString();
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
                  if( genreData2[genresIndex]['name'] == null){
                    return null;
                  }else{
                    return "${genreData2[genresIndex]['name']}";
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
          setState(() {

            loginConfigData = homeApiResponseData['config'];
            topMenuData = topMData['menu'];
            menuList = topMenuData.length;
            fullData = "Bearer ${user['access_token']}!";
            mDataCount = mDataC['movie'];
            movieDataLength = mDataCount.length;

          });

          List.generate(showWatchlist == null ? 0 : showWatchlist.length, (int index){
          });

          dataUser = json.decode(response.body);
          setState(() {

            userDetail = dataUser['user'];
            userRole = userDetail['is_admin'];
            userId = userDetail['id'];
            userName = userDetail['name'];
            userEmail = userDetail['email'];
            userMobile = userDetail['mobile'];
            userDOB = userDetail['dob'];
            userImage = userDetail['image'];
            userCreatedAt = userDetail['created_at'];
            stripeCustomerId = userDetail['stripe_id'];
            userActivePlan = dataUser['current_subscription'];
            userExpiryDate = dataUser['end'];
            status=dataUser['active'];
            userPlanStart=dataUser['start'] != null ? DateTime.parse(dataUser['start']) : 'N/A';
            userPlanEnd= dataUser['end']!=null? DateTime.parse(dataUser['end']): 'N/A';
            currentDate= dataUser['current_date']!=null? DateTime.parse(dataUser['current_date']) : 'N/A';

          });

          setState(() {
            showWatchlist = showWatchlistData['wishlist'];
            userId = userDetail['id'];
            code = dataUser['code'];
            name = userName;
            nameInitial = userName[0];
            email = userEmail;
            expiryDate = userExpiryDate;
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
              dob = "N/A";
            } else {
              dob = userDOB;
            }
            if (userCreatedAt == null) {
              created_at = "N/A";
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
            if(expiryDate == '' || expiryDate == 'N/A' || userExpiryDate == null|| status==0){
              difference=null;
            }

          });
          var router = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new BottomNavigationBarController(

              )
          );
          Navigator.of(context).push(router);

          return (accessToken.body);
        } else {


          final basicDetails = await http.get(
            Uri.encodeFull(APIData.homeDataApi),);
          homeApiResponseData= json.decode(basicDetails.body);

          setState(() {
            loginImageData = homeApiResponseData['login_img'];
            loginConfigData = homeApiResponseData['config'];
            homeDataBlocks = homeApiResponseData['blocks'];
          });

          if(homeDataBlocks != null){
            var router = new MaterialPageRoute(
                builder: (BuildContext context) => new IntroScreen());
            Navigator.of(context).push(router);
          }

          //   print('connected');
        }
      }
    } catch (e){
      print(e);
    }

    return (null);
  }

// Create file to save login credentials
  void createFile(Map<String, String> content, Directory dir, String fileName) {
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    setState(() {
      fileExists = true;
    });
    file.writeAsStringSync(json.encode(content));
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
  }

// Write into file
  void writeToFile(String key, String value) {
//    print("Writing to file!");
    Map<String, String> content = {key: value};
    if (fileExists) {
//      print("File exists");
      Map<dynamic, dynamic> jsonFileContent =
      json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
//      print("File does not exist!");
      createFile(content, dir, fileName);
    }

    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
//    print(fileContent);
  }

  @override
  void initState() {
    _passwordController.addListener(() {
      setState(() {
        pass = _passwordController.text;
      });
    });
    super.initState();
    _isButtonDisabled = false;
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        this.setState(
                () => fileContent = json.decode(jsonFile.readAsStringSync()));
      }
    });
  }

// SignUp heading text
  Widget signUpHeading(){
    return Padding(
      padding: EdgeInsets.only(top:10.0, left: 10.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Register",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }

// Username label text
  Widget userNameLabelText(){
    return Padding(
      padding: EdgeInsets.only(
          left: 25.0, right: 10.0, bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "User Name",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

// Email label text
  Widget emailLabelText(){
    return Padding(
      padding: EdgeInsets.only(
          left: 25.0, right: 10.0, bottom: 10.0,top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }

// password label text
  Widget passwordLabelText(){
    return Padding(
      padding: EdgeInsets.only(
          left: 25.0, right: 10.0, bottom: 10.0, top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Password",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

// confirm password label text
  Widget confirmPasswordLabelText(){
    return Padding(
      padding: EdgeInsets.only(
          left: 25.0, right: 10.0, bottom: 10.0, top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Confirm Password",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

// SignUp page header of StickyHeader widget
  Widget signUpPageStickyHeader(){
    return Stack(
      children: <Widget>[
        /*Container(
          margin: new EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
          child: WavyHeaderImage2(),
        ),
        Container(
          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: WavyHeaderImage(),
        ),
        */
        Container(
          child: WavyHeaderImage3(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20.0),
              child: Container(
                  child: Image.network(
                    '${APIData.logoImageUri}${loginConfigData['logo']}',
                    scale: 0.9,
                  )
              ),
            ),
          ],
        ),
      ],
    );
  }

// Remember me radio button
  Widget rememberMeRadio(){
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: InkWell(
          onTap: _radio,
          child:  new Text("Remember me",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              )
          )
      ),
    );
  }

//Register button tile
  Widget registerButtonTile(){
    return ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            GestureDetector(
              onTap: _radio,
              child: RadioButtonField(_isSelected),
            ),
            SizedBox(
              width: 8.0,
            ),
            rememberMeRadio(),
            SizedBox(
              width: 10.0,
            ),
            goToSignUpButton(),
          ],
        ));
  }

// Content of StickyHeader widget
  Widget stickyHeaderContent(){
    return Column(
      children: <Widget>[
        signUpHeading(),
        SizedBox(
          height: 30.0,
        ),
        Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              userNameLabelText(),
              Padding(
                padding:
                EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: NameField(_nameController),
              ),
              SizedBox(
                height: 10.0,
              ),
              emailLabelText(),
              Padding(
                padding:
                EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: EmailField(_emailController),
              ),
              SizedBox(
                height: 10.0,
              ),
              passwordLabelText(),
              Padding(
                padding:
                EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: HiddenPasswordField(_passwordController,'Enter your password'),
              ),
              SizedBox(
                height: 10.0,
              ),
              confirmPasswordLabelText(),
              Padding(
                padding:
                EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: ConfirmPasswordField(_passwordController,_repeatPasswordController),
              ),

              SizedBox(
                height: 10.0,
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              registerButtonTile(),
              Padding(padding: EdgeInsets.only(bottom: 20.0)),
            ],
          ),
        )
      ],
    );
  }

// SignUp form
  Widget signUpForm(){
    return Form(
      onWillPop: () async {
        return true;
      },
      key: formKey,
      child: Container(
        color: Colors.black.withOpacity(0.75),
        alignment: Alignment.center,
        child: Center(
          child: new ListView(
            children: <Widget>[
              StickyHeader(
                header: signUpPageStickyHeader(),
                content: stickyHeaderContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Go to sign up button
  Widget goToSignUpButton(){
    return Expanded(
      flex: 1,
      child: InkWell(
        child: Material(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            height: 50.0,
            decoration: new BoxDecoration(color: Colors.red),
            /*
            decoration: BoxDecoration(
              borderRadius:
              new BorderRadius.circular(5.0),
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Color.fromRGBO(
                      72, 163, 198, 0.4)
                      .withOpacity(0.4),
                  Color.fromRGBO(
                      72, 163, 198, 0.3)
                      .withOpacity(0.5),
                  Color.fromRGBO(
                      72, 163, 198, 0.2)
                      .withOpacity(0.6),
                  Color.fromRGBO(
                      72, 163, 198, 0.1)
                      .withOpacity(0.7),
                ],
              ),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 10.0,
                  offset: new Offset(1.0, 10.0),
                ),
              ],
            ),
            */
            child: new MaterialButton(
                height: 50.0,
                splashColor: Colors.red,
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  // ignore: unnecessary_statements
                  _isButtonDisabled ? null : _signUp();
                }
            ),
          ),
        ),
      ),
    );
  }

// Build method
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      key: scaffoldKey,
      body: signUpForm(),
    ),);
  }
}








