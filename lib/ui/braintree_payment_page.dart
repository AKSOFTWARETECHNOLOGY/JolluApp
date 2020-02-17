import 'package:flutter/material.dart';
import 'package:braintree_payment/braintree_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:next_hour/ui/subscription.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:next_hour/loading/loading_screen.dart';
import 'package:next_hour/widget/success_ticket.dart';

class BraintreePaymentPage extends StatefulWidget {
  final int index;

  BraintreePaymentPage({Key key, this.index}) : super(key: key);

  @override
  _BraintreePaymentPageState createState() => _BraintreePaymentPageState();
}

class _BraintreePaymentPageState extends State<BraintreePaymentPage> {
  var nonceStatus;
  var noncePayment;
  var msgResponse;
  String createdDate ='';
  String createdTime = '';
  var paymentResponse;
  var subscriptionResponse;
  bool isShowing = false;
  bool isBack = true;
  var ind;

//  Generating client nonce from braintree to access payment services
  Future<String> getClientNonce() async {
    setState(() {
      isShowing = true;
    });
    setState(() {
     isBack = false;
    });

    Fluttertoast.showToast(msg: "Don't press back button.");

    final clientTokenResponse =
        await http.get(Uri.encodeFull(APIData.clientNonceApi), headers: {
      // ignore: deprecated_member_use
      HttpHeaders.AUTHORIZATION: fullData
    });
    var resBody = json.decode(clientTokenResponse.body);
    if (clientTokenResponse.statusCode == 200) {
      braintreeClientNonce = resBody['client'];
//      print("Client Nonce: $braintreeClientNonce");
      payNow(braintreeClientNonce);
    }
    return null;
  }


//  Creating payment and send the require details to server
  payNow(String clientNonce) async {
    BraintreePayment braintreePayment = new BraintreePayment();
    var data = await braintreePayment.showDropIn(
        nonce: clientNonce,
        amount: "${plan_details[widget.index]['amount']}",
        enableGooglePay: true);
//    print("Response of the payment $data");
    nonceStatus = data['status'];
    noncePayment = data['paymentNonce'];
//    print("Nonce Status: $nonceStatus");
    if (data['status'] == 'success') {
      sendPaymentNonce();
    }
  }

//  Saving payment details to your server so that user details can be updated either user is subscribed or not subscribed.
  Future<String> sendPaymentNonce() async {
    final sendNonceResponse =
        await http.post(APIData.sendPaymentNonceApi, body: {
      "amount": "${plan_details[widget.index]['amount']}",
      "nonce": noncePayment,
      "plan_id": "${plan_details[widget.index]['id']}",
    }, headers: {
      // ignore: deprecated_member_use
      HttpHeaders.AUTHORIZATION: fullData
    });
//    print("Server payment ${sendNonceResponse.body}");
    paymentResponse = json.decode(sendNonceResponse.body);
//    print("Payment $paymentResponse");
    msgResponse = paymentResponse['message'];
    subscriptionResponse = paymentResponse['subscription'];
//    var format1 = new DateFormat('d MMM y');
//    var format2 = new DateFormat('HH:mm a');
    var date  = subscriptionResponse['created_at'];
    var time = subscriptionResponse['created_at'];
//    print("date: $date");
//    print("time: $time");
    createdDate = DateFormat('d MMM y').format(DateTime.parse(date));
    createdTime = DateFormat('HH:mm a').format(DateTime.parse(time));


    // ignore: unrelated_type_equality_checks
    if (sendNonceResponse.statusCode != '') {
      setState(() {
        isShowing = false;
      });
    }
    if (sendNonceResponse.statusCode == 200) {
//      Fluttertoast.showToast(msg: "Your Transaction Successful");
      setState(() {
        isShowing = false;
      });
      goToDialog(createdDate, createdTime);
    }
    return null;
  }
//  WillPopScope
  Future<bool> _willPopCallback() async {
    return isBack;
  }

  /*
  After creating successful payment and saving details to server successfully.
  Create a successful dialog
*/
  Widget appBar() => AppBar(
    title: Text(
      "Subscription Plans",
      style: TextStyle(fontSize: 16.0),
    ),
    centerTitle: true,
    backgroundColor: Color.fromRGBO(34, 34, 34, 1.0).withOpacity(0.98),
  );

  Widget closeFloatingButton() => FloatingActionButton(
    backgroundColor: Colors.black,
    child: Icon(
      Icons.clear,
      color: Colors.white,
    ),
    onPressed: () {
      var router = new MaterialPageRoute(
          builder: (BuildContext context) => new LoadingScreen());
      Navigator.of(context).push(router);
    },
  );

  Widget goToDialog(subdate, time) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
        new GestureDetector(
          child: Container(
            color: Colors.black.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SuccessTicket(msgResponse, subdate, name, time, ind),
                SizedBox(
                  height: 10.0,
                ),
                closeFloatingButton(),
              ],
            ),
          ),
        )
    );
    return null;
  }

  Widget _body(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Amount: " +
              '${plan_details[widget.index]['amount']} ' + '${plan_details[widget.index]['currency']}'),
          SizedBox(
            height: 10.0,
          ),
          isShowing == true
              ? CircularProgressIndicator()
              : FlatButton(
            onPressed: getClientNonce,
            color: Color.fromRGBO(72, 163, 198, 1.0),
            child: Text(
              "Pay Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
     isBack = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ind = widget.index;
    return WillPopScope(
        child: Scaffold(
          appBar: appBar(),
          body: _body(),
        ), onWillPop: _willPopCallback);
  }
}

