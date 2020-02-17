import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/utils/color_loader.dart';
import 'package:next_hour/ui/select_payment.dart';

// ignore: non_constant_identifier_names
var plan_details;

class SubscriptionPlan extends StatefulWidget {
  @override
  SubscriptionPlanState createState() => SubscriptionPlanState();
}

class SubscriptionPlanState extends State<SubscriptionPlan> {

//  Getting plan details from server
    Future<String> planDetails() async {
      final basicDetails = await http.get(
        Uri.encodeFull(APIData.homeDataApi),
      );
      var homeDataResponseDetails = json.decode(basicDetails.body);
      setState(() {
        plan_details = homeDataResponseDetails['plans'];
      });
      return null;
    }

    @override
    void initState() {
      super.initState();
      this.planDetails();
    }

//  List used to show all the plans using home API
    List<Widget> _buildCards(int count) {
      List<Widget> cards = List.generate(count, (int index) {
        var dailyAmount =
            plan_details[index]['amount'] / plan_details[index]['interval_count'];

        String dailyAmountAp = dailyAmount.toStringAsFixed(2);

  //      Used to check soft delete status so that only active plan can be showed
        if(plan_details[index]['status'] == 1){
          return plan_details[index]['delete_status'] == 0 ? SizedBox.shrink() : subscriptionCards(index, dailyAmountAp);
        }else{
          return SizedBox.shrink();
        }

      });

      return cards;
    }

//  App bar
    Widget appBar() => AppBar(
      title: Text(
        "Subscription Plans",
        style: TextStyle(fontSize: 16.0),
      ),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(34, 34, 34, 1.0).withOpacity(0.98),
    );

//  Subscribe button
    Widget subscribeButton(index){
      return Padding(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                height: 40.0,
                width: 150.0,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      Color.fromRGBO(72, 163, 198, 0.4)
                          .withOpacity(0.4),
                      Color.fromRGBO(72, 163, 198, 0.3)
                          .withOpacity(0.5),
                      Color.fromRGBO(72, 163, 198, 0.2)
                          .withOpacity(0.6),
                      Color.fromRGBO(72, 163, 198, 0.1)
                          .withOpacity(0.7),
                    ],
                  ),
                ),
                child: new MaterialButton(
                    height: 50.0,
                    splashColor: Color.fromRGBO(72, 163, 198, 0.9),
                    child: Text(
                      "Subscribe",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
  //   Working after clicking on subscribe button
                      var router = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new SelectPayment(
                            indexPer: index,
                          ));
                      Navigator.of(context).push(router);
                    }),
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      );
    }

//  Amount with currency
    Widget amountCurrencyText(index){
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${plan_details[index]['amount']}",
                      style: TextStyle(
                          color: Colors.white, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 3.0,
                    ),
                    Text('${plan_details[index]['currency']}'),
                  ],
                )),
          ]);
    }

//  Daily amount
    Widget dailyAmountIntervalText(dailyAmountAp, index){
      return Row(children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 100.0),
            child: Text(
              "$dailyAmountAp / ${plan_details[index]['interval']}",
              style: TextStyle(
                  color: Colors.white, fontSize: 8.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);
    }

//  Plan Name
    Widget planNameText(index){
      return Container(
        height: 35.0,
        color: Color.fromRGBO(20, 20, 20, 1.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                '${plan_details[index]['name']}',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

//  Subscription cards
    Widget subscriptionCards(index, dailyAmountAp){
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 5.0,
              child: Column(
                children: <Widget>[
                  planNameText(index),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  amountCurrencyText(index),
                  dailyAmountIntervalText(dailyAmountAp,index),
                ],
              ),
            ),
            subscribeButton(index),
          ],
        ),
      );
    }

// Scaffold body
    Widget scaffoldBody(){
      return plan_details == null ? Container(
        child: ColorLoader(),) : Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: _buildCards(
                  plan_details == null ? 0 : plan_details.length),
            ),
          ));
    }

//  Build Method
    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return SafeArea(
        child: Scaffold(
          appBar: appBar(),
          body: scaffoldBody(),
        ),
      );
    }
}







