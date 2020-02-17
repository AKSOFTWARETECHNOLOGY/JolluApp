import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/home.dart';

class IntroScreen extends StatefulWidget {

  @override
  IntroScreenState createState() => IntroScreenState();
}
class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  Function goToTab;

  @override
  void initState() {
    super.initState();

      List.generate(homeDataBlocks == null ? 0 : homeDataBlocks.length, (int i){
        return slides.add(
            new Slide(
              title: "${homeDataBlocks[i]['heading']}",
              styleTitle:
              TextStyle(color: Color.fromRGBO(72,163,198, 1.0), fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: 'RobotoMono'),
              description:
              "${homeDataBlocks[i]['detail']}",
              styleDescription:
              TextStyle(color: Colors.white, fontSize: 20.0, fontStyle: FontStyle.italic, fontFamily: 'Raleway'),
              pathImage: "${APIData.landingPageImageUri}${homeDataBlocks[i]['image']}",
            ),
         );
      });
  }
//  WillPopScope to handle back press.
    Future<bool> onWillPopS() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Press again to exit.");
        return Future.value(false);
      }
      return  SystemNavigator.pop();


    }

//  After done pressed on intro slider
    void onDonePress() {
      // Back to the first tab
      var router = new MaterialPageRoute(
                builder: (BuildContext context) => new Home());
          Navigator.of(context).push(router);
  //    this.goToTab(0);
    }

//  Counting index and changing UI page dynamically.
    void onTabChangeCompleted(index) {
      // Index of current tab is focused
    }

//  Next button
    Widget renderNextBtn() {
      return Icon(
        Icons.navigate_next,
        color: Color.fromRGBO(72,163,198, 1.0),
        size: 35.0,
      );
    }

//  Done button or last page of intro slider
    Widget renderDoneBtn() {
      return Icon(
        Icons.done,
        color: Color.fromRGBO(72,163,198, 1.0),
      );
    }

//  Skip button to go directly on last page of intro slider
    Widget renderSkipBtn() {
      return Icon(
        Icons.skip_next,
        color: Color.fromRGBO(72,163,198, 1.0),
      );
    }

//  Custom tabs
    List<Widget> renderListCustomTabs() {
      List<Widget> tabs = new List();
      for (int i = 0; i < slides.length; i++) {
        Slide currentSlide = slides[i];
        tabs.add(Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 70.0, top: 0.0),
            child: Center(
               child: Stack(
                children: <Widget>[
                Container(
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(34, 34, 34, 1.0).withOpacity(1.0),
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.0), bottomLeft: Radius.circular(0.0)),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.black87.withOpacity(0.6),
                          blurRadius: 20.0,
                          offset: new Offset(0.0, 5.0),
                        ),
                      ],
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                        image: new NetworkImage(
                          currentSlide.pathImage
                        ),
                      ),
                    ),
                  ),
                Container(
                  alignment: Alignment.center,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Text(
                          currentSlide.title,
                          style: currentSlide.styleTitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Text(
                          currentSlide.description,
                          style: currentSlide.styleDescription,
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        margin: EdgeInsets.only(top: 20.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
        ));
      }
      return tabs;
    }

// Intro slider
    Widget introSlider(){
      return IntroSlider(
        // List slides
        slides: this.slides,

        // Skip button
        renderSkipBtn: this.renderSkipBtn(),
        colorSkipBtn: Color.fromRGBO(72,163,198, 0.3),
        highlightColorSkipBtn: Color.fromRGBO(72,163,198, 1.0),

        // Next button
        renderNextBtn: this.renderNextBtn(),

        // Done button
        renderDoneBtn: this.renderDoneBtn(),
        onDonePress: this.onDonePress,
        colorDoneBtn: Color.fromRGBO(72,163,198, 0.3),
        highlightColorDoneBtn: Color.fromRGBO(72,163,198, 1.0),

        // Dot indicator
        colorDot: Color.fromRGBO(72,163,198, 1.0),
        sizeDot: 13.0,
        typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

        // Tabs
        listCustomTabs: this.renderListCustomTabs(),
        backgroundColorAllSlides: Colors.white,
        refFuncGoToTab: (refFunc) {
          this.goToTab = refFunc;
        },

        // Show or hide status bar
        shouldHideStatusBar: true,

        // On tab change completed
        onTabChangeCompleted: this.onTabChangeCompleted,
      );
    }

    @override
    Widget build(BuildContext context) {
      return WillPopScope(
          child: introSlider(),
          onWillPop: onWillPopS);
    }
}