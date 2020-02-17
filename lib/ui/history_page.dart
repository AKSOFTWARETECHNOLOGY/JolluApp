import 'package:flutter/material.dart';
import 'package:next_hour/ui/other_payment_history.dart';
import 'package:next_hour/ui/stripe_payment_history.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
//  App bar
    Widget appBar() {
    return AppBar(
      title: Text(
        "Payment History",
        style: TextStyle(fontSize: 16.0),
      ),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(34, 34, 34, 1.0).withOpacity(0.98),
    );
  }

//  Text on container to select stripe history
    Widget stripeText(){
    return Expanded(
      flex: 4,
      child: Text("Stripe Payment History"),
    );
  }

//  Container to select stripe payment history
    Widget goToStripeHistory(){
    return InkWell(
      child: Container(
        height: 80.0,
        child: Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(35.0, 0.0, 10.0, 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text("Stripe Payment History"),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.arrow_forward_ios, size: 15.0,),
                  )
                ],
              ),
            )),
      ),

//              This onTap take you to the next screen that contains stripe payment history.
      onTap: (){
        var router = new MaterialPageRoute(
            builder: (BuildContext context) => new StripePaymentHistory());
        Navigator.of(context).push(router);
      },
    );
  }

//  Container to choose other payment history
    Widget goToOtherHistory(){
    return InkWell(
      child: Container(
        height: 80.0,
        child: Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(35.0, 0.0, 10.0, 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text("Other Payment History"),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.arrow_forward_ios, size: 15.0,),
                  )
                ],
              ),
            )
        ),
      ),

      //              This onTap take you to the next screen that contains payment history except stripe.
      onTap: (){
        var router = new MaterialPageRoute(
            builder: (BuildContext context) => new OtherPaymentHistory());
        Navigator.of(context).push(router);
      },
    );
  }

//  Scaffold body contains overall UI of this page
    Widget scaffoldBody(){
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            goToStripeHistory(),
            Container(
              height: 2.0,
            ),
            goToOtherHistory(),
          ],
        ),
      );
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: appBar(),
        body: scaffoldBody(),
      );
    }
}