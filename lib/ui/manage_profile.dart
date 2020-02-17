import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';
//import 'package:fluttery_seekbar/fluttery_seekbar.dart';
import 'package:seekbar/seekbar.dart';
import 'package:next_hour/ui/edit_profile.dart';

File jsonFile;
var sw='';
Map<dynamic, dynamic> fileContent;
var acct;

class ManageProfileForm extends StatefulWidget {
  final String name;


  ManageProfileForm({Key key, this.name}) : super(key: key);

  @override
  ManageProfileFormState createState() => ManageProfileFormState();
}

class ManageProfileFormState extends State<ManageProfileForm> {
  DateTime _date;
  var planDays;
  var progressWidth;
  var diff;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

//  Pop menu button to edit profile
    Widget _selectPopup() {
    return PopupMenuButton<int>(
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          value: 1,
          child: Text("Edit Profile"),
        ),
      ],
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (value) {
        if (value == 1) {
          print("value:$value");
          var route = MaterialPageRoute(
              builder: (context) => EditProfilePage());
          Navigator.push(
              context, route);
        }
      },
      icon: Icon(Icons.more_vert),
    );
  }

//  User profile image
    Widget userProfileImage(){
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Container(
        height: 170.0,
        width: 130.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
        ),
        child:  ClipRRect(
          borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
          child: userImage != null ? Image.network(
            "${APIData.profileImageUri}"+"$userImage",
            scale: 1.7,
            fit: BoxFit.cover,
          ):
          Image.asset(
            "assets/avatar.png",
            scale: 1.7,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

//  App bar
    Widget appBar(){
    return AppBar(
      elevation: 0.0,
      title: Text("Manage Profile",style: TextStyle(fontSize: 16.0),),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(34, 34, 34, 1.0),
    );
  }

//  Rounded SeekBar
    Widget roundedSeekBar() {
    diff = difference == null ? sw:'$difference'+' Days Remaining';
    /*return RadialSeekBar(
      trackColor: Color.fromRGBO(20, 20, 20, 1.0),
      trackWidth: 8.0,
      progressColor: difference == null ? Colors.red : Color.fromRGBO(72, 163, 198, 1.0),
      progressWidth: 8.0,
      progress: difference == null ? 1.0: progressWidth,
      centerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(diff),
          )
        ],
      ),
    );
    */
  }

//  Rounded SeekBar Container
    Widget roundedSeekBarContainer(){
    return Container(
      height: 200.0,
      margin: EdgeInsets.only(top: 450.0, bottom: 15.0),
      padding: EdgeInsets.only(left: 50.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: SizedBox(
              width: 200.0,
              height: 200.0,
              child: roundedSeekBar(),
            ),

          ),
        ],
      ),
    );
  }

//  Pop menu button to edit profile
    Widget popUpMenu(){
    var w = MediaQuery.of(context).size.width;
    w = w - 40;
    return Padding(
        padding: EdgeInsets.only(left: w, top: 26.0,),
        child:
        _selectPopup()
    );
  }

//  Account status text
    Widget accountStatusText(){
      return new Padding(
        padding: EdgeInsets.only(right: 70.0, top: 60.0),
        child: Text('Account status:', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),),
      );
    }

//  When user is active
    Widget activeStatus(){
      return Padding(
          padding: EdgeInsets.only(right: 70.0),
          child:  Row(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 10.0),
                width: 20.0,
                height: 20.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color.fromRGBO(125,183,91, 1.0), width: 1.0)
                ),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: new BoxDecoration(
                        //                    color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color.fromRGBO(125,183,91, 1.0), width: 2.5)
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 5.0),
                child:   Text('Active', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),),
              ),
            ],
          )
      );
    }

//  When user is inactive
    Widget inactiveStatus(){
      return Padding(
          padding: EdgeInsets.only(right: 70.0),
          child:  Row(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 10.0),
                width: 20.0,
                height: 20.0,
                decoration: new BoxDecoration(
                  //                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 1.0)
                ),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 2.5)
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 5.0),
                child:   Text('Inactive', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),),
              ),
            ],
          )
      );
    }

//  When user account status
    Widget userAccountStatus(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              accountStatusText(),
  //    Radial progress bar is used to show the remaining days of user subscription
              status==0? inactiveStatus() : activeStatus(),
            ],
          ),
        ],
      );
    }

//  User subscription end date
    Widget subExpiryDate(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[

  //    This shows subscription end date on manage profile page and also show status of user subscription.
              Container(
                margin: EdgeInsets.only(top: 125.0, right: 40.0),
                child:   Text(expiryDate == ''? '': 'Subscription will end on', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),textAlign: TextAlign.right,),
              ),
              Container(
                margin: EdgeInsets.only(top: 2.0, right: 40.0),
                child:   status == 1 ? Text(expiryDate == ''? sw :'${DateFormat.yMMMd().format(_date)}', style: TextStyle(color: Colors.white, fontSize: 12.0, ),textAlign: TextAlign.right,) :  Text( sw, style: TextStyle(color: Colors.white, fontSize: 12.0, ),textAlign: TextAlign.right,),
              )
            ],
          )
        ],
      );
    }

//  Divider Container
    Widget dividerContainer(){
      return Expanded(
        flex:0,
        child: new Container(
          height: 80.0,
          width: 1.0,
          decoration: new BoxDecoration(
            border: Border(
              right: BorderSide( //                    <--- top side
                color: Colors.white10,
                width: 2.0,
              ),
            ),
          ),
        ),
      );
    }

//  Show mobile number
    Widget mobileNumberText(){
      return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.only(top: 0.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Mobile Number', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),textAlign: TextAlign.right,),
                SizedBox(height: 5.0,),
                Text(mobile, style: TextStyle(color: Colors.white, fontSize: 14.0, ),textAlign: TextAlign.right,)
              ]),
        ),
      );
    }

//  Show date of birth
    Widget dobText(){
      return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.only(top: 0.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Date of Birth', style: TextStyle(color: Colors.white70, fontSize: 12.0, ),textAlign: TextAlign.right,),
                SizedBox(height: 5.0,),
                Text(dob, style: TextStyle(color: Colors.white, fontSize: 14.0, ),textAlign: TextAlign.right,)
              ]),
        ),

      );
    }

//  Date of birth and mobile text container
    Widget dobAndMobile(){
      return Container(
        height: 80.0,
        margin: EdgeInsets.only(top: 210.0),
        padding: EdgeInsets.only(left: 50.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            dobText(),
            dividerContainer(),
            mobileNumberText(),
          ],
        ),
      );
    }

//  Show joined date text
    Widget joinedDateText(){
      var split = created_at.split(' ').map((i) {
        if (i == "") {
          return Divider();
        } else {
          return Text(i,style: TextStyle(color: Colors.white70, fontSize: 14.0, ),textAlign: TextAlign.left,);
        }
      }).toList();

      return Expanded(
        flex:1,
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Joined on", style: TextStyle(color: Colors.white, fontSize: 24.0),textAlign: TextAlign.left,),
                SizedBox(height: 5.0,),
                split[0],
                SizedBox(height: 3.0,),
                split[1]
              ]),
        ),

      );
    }

//  Show name and joined date container
    Widget nameAndJoinedDateContainer(){
      return Container(
        height: 80.0,
        margin: EdgeInsets.only(top: 322.0),
        padding: EdgeInsets.only(left: 50.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name, style: TextStyle(color: Colors.white, fontSize: 24.0),textAlign: TextAlign.left,),
                      SizedBox(height: 5.0,),
                      Text(email, style: TextStyle(color: Colors.white70, fontSize: 14.0, ),textAlign: TextAlign.left,)
                    ]),
              ),
            ),
            joinedDateText(),
          ],
        ),
      );
    }

//  Container used as border
    Widget borderContainer1(){
      return Container(
        margin: EdgeInsets.only(left: 50.0),
        height: 210.0,
        decoration: new BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white10,
              width: 2.0,
            ),
          ),
        ),
      );
    }

//  Container used as border
    Widget borderContainer2(){
      return Container(
        margin: EdgeInsets.only(left: 50.0),
        height: 292.0,
        decoration: new BoxDecoration(
          border: Border(
            bottom: BorderSide( //                    <--- top side
              color: Colors.white10,
              width: 2.0,
            ),
          ),
        ),
      );
    }

//  Overall UI of this page is in stack
    Widget stack() {
      return Stack(
        children: <Widget>[
          userProfileImage(),
          userAccountStatus(),
          subExpiryDate(),
          borderContainer1(),
          dobAndMobile(),
          borderContainer2(),
          nameAndJoinedDateContainer(),
          roundedSeekBarContainer(),
          popUpMenu(),
        ],
      );
    }

//  Scaffold body
    Widget scaffoldBody(){
      return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              userProfileImage(),
              userAccountStatus(),
              subExpiryDate(),
              borderContainer1(),
              dobAndMobile(),
              borderContainer2(),
              nameAndJoinedDateContainer(),
              roundedSeekBarContainer(),
              popUpMenu(),
            ],
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      if(expiryDate == '' || expiryDate == 'N/A' || userExpiryDate == null|| status==0){
        sw = 'You are not Subscribed';
        setState(() {
          difference=null;
        });
      }else{
        setState(() {
          _date= userPlanEnd;
        });
        difference = status==1 ? _date.difference(currentDate).inDays: 0.0;
        planDays=userPlanEnd.difference(userPlanStart).inDays;
        print(difference/planDays);
        progressWidth=difference/planDays;
      }
      return SafeArea(
        child: Scaffold(
          appBar: appBar(),
          body: scaffoldBody(),
        ),);
    }
}
