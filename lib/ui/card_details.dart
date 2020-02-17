import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:next_hour/ui/subscription.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/loading/loading_screen.dart';
import 'package:next_hour/ui/credit_card_form.dart';
import 'package:next_hour/ui/credit_card_model.dart';
import 'package:next_hour/ui/flutter_credit_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:next_hour/utils/profile_tile.dart';
import 'package:stripe_api/stripe_api.dart';
import 'package:http/http.dart' as http;

class CardDetails extends StatefulWidget {
  final int index1;
  final String coupanCode;
  CardDetails({Key key, @required this.index1, @required this.coupanCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CardDetailsState();
  }
}

class CardDetailsState extends State<CardDetails> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isDataAvailable = true;
  bool isAmex = false;
  var cardLast4;
  var cardtype;
  var customerStripeId;
  var planId;
  var subId;

  void initState() {
    super.initState();

    Stripe.init(stripeKey);
  }

//  Customer is created on stripe for making payment.
  Future<String> _createCustomer() async {

    final menuResponse = await http.post(
        Uri.encodeFull("https://api.stripe.com/v1/customers?name="+"$name"+"&email="+"$email"),
        headers: {
          // ignore: deprecated_member_use
          HttpHeaders.AUTHORIZATION: "Bearer $stripePass"
        });
    if(menuResponse.statusCode == 200){
      var customerStripeDetails = json.decode(menuResponse.body);
      setState(() {
        customerStripeId = customerStripeDetails['id'];
      });

      _saveCard(customerStripeId);
    }
    return null;
  }

  void _saveCard(customerStripeId) {
    List x = expiryDate.split("/");
    var x1 = int.parse(x[0]);
    var x2 = int.parse(x[1]);
    StripeCard card = new StripeCard(
        number: cardNumber, cvc: cvvCode, expMonth: x1, expYear: x2);
    card.name = cardHolderName;
    Stripe.instance.createCardToken(card).then((c) {
      _saveCardForCustomer(customerStripeId, c.id);
    }).then((source) {
    }).catchError((error) {
      String message= '$error';
      showErrorDialog(message);
    });
  }

//  Stripe card is automatically saved for customer for future payment.

  Future<String> _saveCardForCustomer(customerStripeId, cardid) async {
    final saveCardResponse = await http.post(
        Uri.encodeFull("https://api.stripe.com/v1/customers/"+"$customerStripeId"+"/sources?source="+"$cardid"),
        headers: {
          // ignore: deprecated_member_use
          HttpHeaders.AUTHORIZATION: "Bearer $stripePass"
        });
    var cardDetails = json.decode(saveCardResponse.body);
    if(saveCardResponse.statusCode == 200){
      cardid = cardDetails['id'];
      cardtype=cardDetails['funding'];
      cardtype = capitalize(cardtype);
      var cardBrand=cardDetails['brand'];
      cardLast4=cardDetails['last4'];
      _createSubscription(customerStripeId, cardid, cardtype, cardBrand, cardLast4);
    }else{
      var code = cardDetails['error']['code'];
      if(code == 'card_declined'){
        var message = 'Your card was declined!';
        showErrorDialog(message);
      }
      setState(() {
        isDataAvailable = true;
      });
    }

    return null;
  }

//  Creating stripe subscription form the customer using customer Id and plan.
  Future<String> _createSubscription(customerStripeId, cardid, cardtype, cardBrand, cardLast4) async {
    var subscriptionResponse;
    if(widget.coupanCode != ''){
      var stripeUri = "https://api.stripe.com/v1/customers/"+"$customerStripeId"+"/subscriptions?plan="+"${plan_details[widget.index1]['plan_id']}"+"&quantity=1&default_source="+"$cardid"+"&coupon="+"${widget.coupanCode}";
      subscriptionResponse = await http.post(
          Uri.encodeFull("$stripeUri"),
          headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: "Bearer $stripePass"
          });
    }
    else{
      subscriptionResponse = await http.post(
          Uri.encodeFull("https://api.stripe.com/v1/customers/"+"$customerStripeId"+"/subscriptions?plan="+"${plan_details[widget.index1]['plan_id']}"+"&quantity=1&default_source="+"$cardid"),
          headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: "Bearer $stripePass"
          });
    }

    var subscriptionDetail = json.decode(subscriptionResponse.body);
    var subscriptionDate = subscriptionDetail['created'];
    var transResponse= subscriptionDetail['id'];

    if(subscriptionResponse.statusCode == 200){
      readTimestamp(subscriptionDate,  cardtype, cardBrand, cardLast4);
      subId = transResponse;
      _sendStripeDetailsToServer();
    }else{
      var code = subscriptionDetail['error']['code'];
      if(code == 'customer_max_subscriptions'){
        var message = 'Already has the maximum 25 current subscriptions!';
        showErrorDialog(message);
      }

      setState(() {
        isDataAvailable = true;

      });

    }
    return null;
  }

//  Send stripe payment subscription to the next hour server
  Future<String> _sendStripeDetailsToServer() async{
    // ignore: unused_local_variable
    final response = await http.post( APIData.stripeProfileApi, body: {
      "customer": customerStripeId,
      "type": cardtype,
      "card": cardLast4,
      "transaction": subId,
    },
        headers: {
          // ignore: deprecated_member_use
          HttpHeaders.AUTHORIZATION: fullData,
        });
    return null;
  }
//    Validation alert dialog
  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: AlertDialog(
              backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
              contentPadding: const EdgeInsets.all(16.0),
              title: Text('Oops!'),
              content: const Text('Please enter all fields!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok',style: TextStyle(fontSize: 16.0),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
//  Show success dialog
  void showSuccessDialog() {
    setState(() {
      isDataAvailable = false;
    });
  }
//  Show error dialog
  void showErrorDialog(message){
    setState(() {
      isDataAvailable = true;
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                errorTicket(message),
                SizedBox(
                  height: 10.0,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ));
  }

  String readTimestamp(int timestamp, cardtype, cardBrand, cardLast4) {
    var now = new DateTime.now();
    var format1 = new DateFormat('d MMM y');
    var format2 = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var subdate = '';
    var time = '';
    subdate = format1.format(date);
    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {

      time = format2.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {

        time = diff.inDays.toString() + ' DAY AGO';
      } else {

        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {

        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {


        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }
    setState(() {
      Future.delayed(Duration(seconds: 1)).then((_) => goToDialog(subdate, time, cardtype, cardBrand, cardLast4));
    });
    return time;
  }

  getCardTypeIcon(String cardNumber) {
    Widget icon;
    switch (detectCCType(cardNumber)) {
      case CardType.visa:
        icon = Image.asset(
          'icons/visa2.png',
          height: 48,
          width: 48,
//          package: 'flutter_credit_card',
        );
        isAmex = false;
        break;

      case CardType.americanExpress:
        icon = Image.asset(
          'icons/amex.png',
          height: 48,
          width: 48,
//          package: 'flutter_credit_card',
        );
        isAmex = true;
        break;

      case CardType.mastercard:
        icon = Image.asset(
          'icons/mastercard.png',
          height: 48,
          width: 48,
//          package: 'flutter_credit_card',
        );
        isAmex = false;
        break;

      case CardType.discover:
        icon = Image.asset(
          'icons/discover.png',
          height: 48,
          width: 48,
//          package: 'flutter_credit_card',
        );
        isAmex = false;
        break;

      default:
        icon = Container(
          height: 48,
          width: 48,
        );
        isAmex = false;
        break;
    }

    return icon;
  }


  Widget appBar() => AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){

      Navigator.pop(context);

      }),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:  MainAxisAlignment.end,
        children: <Widget>[

//    Setting logo in the app bar from server
          Image.network(
          '${APIData.logoImageUri}${loginConfigData['logo']}',
          scale: 1.7,
              )
            ],
          ),
      backgroundColor: Color.fromRGBO(34,34,34, 1.0).withOpacity(0.98),

      );

//  Payment Process on tapping button
  Widget floatingBar() {
    return Container(
      child:
      isDataAvailable
          ?
      Material(
        borderRadius: BorderRadius.circular(25.0),
        child:  Container(
          decoration: ShapeDecoration(
              shape: StadiumBorder(),
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
              )
          ),
          child: FloatingActionButton.extended(
            onPressed: () {
              if(cardNumber.length==0|| expiryDate.length==0 || cardHolderName.length==0|| cvvCode.length==0)
              {
                _ackAlert(context);

              }else
              {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                Fluttertoast.showToast(msg: "Don't press back button.");
                if(stripeCustomerId != null){
                  setState(() {
                    customerStripeId = stripeCustomerId;
                  });
                  _saveCard(stripeCustomerId);
//              _createCustomer();
                }else{
                  _createCustomer();
                }
                showSuccessDialog();

              }
            },
            backgroundColor: Colors.transparent,
            icon: Icon(
              FontAwesomeIcons.amazonPay,
              color: Colors.white,
            ),
            label: Text(
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      )
          : CircularProgressIndicator(),
    );
  }

  Widget successTicket(subdate, time, cardtype, cardBrand, cardLast4) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Color.fromRGBO(250, 250, 250, 1.0),
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ProfileTile(
                title: "Thank You!",
                textColor:  Color.fromRGBO(125, 183, 91, 1.0),
                subtitle: "Your transaction was successful",
              ),
              ListTile(
                title: Text("Date",style: TextStyle(color: Colors.black)),
                subtitle: Text(subdate,style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),),
                trailing: Text(time,style: TextStyle(color: Colors.black)),
              ),
              ListTile(
                title: Text(name,style: TextStyle(color: Colors.black),),
                subtitle: Text(email,style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),),
                trailing: userImage != null ? Image.network(
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
              ListTile(
                title: Text("Amount",style: TextStyle(color: Colors.black),),
                subtitle: Text("${plan_details[widget.index1]['amount']}"+" ${plan_details[widget.index1]['currency']}",style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),),
                trailing: Text("Completed",style: TextStyle(color: Colors.black),),
              ),

              Card(

                clipBehavior: Clip.antiAlias,
                elevation: 0.0,
//              color: Color.fromRGBO(34, 34, 34, 1.0),
                child: ListTile(
                  leading: getCardTypeIcon(cardNumber),
                  title: Text("$cardtype Card"),
                  subtitle: Text("$cardBrand ending $cardLast4"),
                  trailing: Icon(
                    FontAwesomeIcons.ccStripe,
                    color: Color.fromRGBO(125, 183, 91, 1.0),
                    size: 30.0,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
//  Container for error message
  Widget errorTicket(message) {
    return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16.0),
    child: Material(
      color: Color.fromRGBO(250, 250, 250, 1.0),
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProfileTile(
              title: "Oops!",
              textColor: Colors.red,
              subtitle: "Your transaction was rejected",
            ),
            ListTile(
              title: Text(message,style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _scaffoldBody() {
    return SafeArea(
    child: Column(
      children: <Widget>[
        CreditCardWidget(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          showBackView: isCvvFocused,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: CreditCardForm(
              onCreditCardModelChange: onCreditCardModelChange,
            ),
          ),
        )
      ],
    ),
  );
  }

  goToDialog(subdate, time, cardtype, cardBrand, cardLast4) {
    setState(() {
      isDataAvailable = true;
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
        new GestureDetector(
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                successTicket(subdate, time, cardtype, cardBrand, cardLast4),
                SizedBox(
                  height: 10.0,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    var router = new MaterialPageRoute(
                        builder: (BuildContext context) => new LoadingScreen()
                    );
                    Navigator.of(context).push(router);
                  },
                )
              ],
            ),
          ),
        )
    );
  }

  Map<CardType, Set<List<String>>> cardNumPatterns =
  <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
          (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
          cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,

      body: _scaffoldBody(),
      floatingActionButton: floatingBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}