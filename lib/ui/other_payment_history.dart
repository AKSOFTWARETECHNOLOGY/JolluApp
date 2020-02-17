import 'package:flutter/material.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/model/paypal_history_model.dart';
import 'package:next_hour/utils/seperator2.dart';
import 'package:next_hour/widget/blank_history.dart';

class OtherPaymentHistory extends StatefulWidget {
  final int index;
  OtherPaymentHistory({Key key,this.index}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OtherPaymentHistoryState();
  }
}

class OtherPaymentHistoryState extends State<OtherPaymentHistory> {
  List<HistoryModel> itemList;

// init state
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      this._historyList();
    }

//  App bar
    Widget appBar(){
    return AppBar(
      title: Text("Other Payment History",style: TextStyle(fontSize: 16.0),),
      centerTitle: true,
      backgroundColor:
      Color.fromRGBO(34,34,34, 1.0).withOpacity(0.98),
    );
  }

//  Subscription start date and end date
    Widget subscriptionFromTo(i){
      return Container(
        child: Text(
          'From' +
              ' ' +
              itemList[i].subscriptionFrom +
              ' ' +
              'To' +
              '\n' +
              itemList[i].subscriptionTo,
          style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              letterSpacing: 0.8,
              height: 1.3,
              fontWeight: FontWeight.w500),
        ),
      );
    }

//    Payment amount
    Widget amount(i){
      return Container(
        child: itemList[i].currency[0] != null ? Text(
          itemList[i].price.toString() +' '+ itemList[i].currency[0].toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
        ) : Text(
          itemList[i].price.toString() +' '+ itemList[i].currency[0].toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
        ),
      );
    }

//   Payment created date
    Widget createdDate(i){
      return Expanded(
        flex: 2,
        child: Text(
          itemList[i].createdDate + ' via ' + '\n' + itemList[i].paymentMethod,
          style:
          TextStyle(color: Colors.white, fontSize: 12.0),
        ),
      );
    }

//    Row transaction id
    Widget transactionId(i){
      return Expanded(
        child: Text(
          'Transaction ID:' + '\n' + itemList[i].paymentId,
          style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              height: 1.3),
        ),
      );
    }

//    Row plan name
    Widget planNameRow(i){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          Expanded(
              child: Text(itemList[i].planName[0].toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
              )
          ),
        ],
      );
    }

//    Row separator
    Widget rowSeparator(){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
            child: Separator2(),
          ),
        ],
      );
    }

//    Row created date
    Widget rowCreatedDate(i){
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
            ),
            createdDate(i),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  amount(i),
                  SizedBox(
                    height: 3.0,
                  ),
                  subscriptionFromTo(i),
                ],
              ),
            ),
          ],
        ),
      );
    }

//    Row transaction id
    Widget rowTransactionId(i){
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
            ),
            transactionId(i),
          ],
        ),
      );
    }

//   Cards that display history
    Widget historyCard(i){
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16.0 / 6.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  ),
                  planNameRow(i),
                  rowSeparator(),
                  rowCreatedDate(i),
                  rowTransactionId(i),
                ],
              ),
            ),
          ],
        ),
      );
    }

//  Scaffold body content
    Widget scaffoldBody(){
      return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child:
            userPaypalHistory.length == 0 ?
            BlankHistoryContainer()
                : Column(
              children: _buildCards(itemList.length) ,
            ),
          )
      );
    }

//  Build method
    @override
    Widget build(BuildContext context) {
      itemList = _historyList();
      // TODO: implement build
      return SafeArea(
        child: Scaffold(
            appBar: appBar(),
            backgroundColor: Color.fromRGBO(34,34,34, 0.0),
            body: scaffoldBody(),
        ),
      );
    }

//  Cards that shows history
    List <Card> _buildCards(int count) {
      print(itemList.length);

    for(var i=0; i<itemList.length; i++){
      List<Card> cards = List.generate(
        count,
        (i) => historyCard(i),
      );
      return cards;
      }
    return null;
    }

//  List of payment history excepting stripe payment
    List<HistoryModel> _historyList() {
      return List<HistoryModel>.generate(userPaypalHistory == null ? 0 : userPaypalHistory.length, (int index){
        return new HistoryModel(
          id: userPaypalHistory[index]['id'],
          userId: userPaypalHistory[index]['user_id'],
          userName: userPaypalHistory[index]['user_name'],
          paymentId: userPaypalHistory[index]['payment_id'],
          price: userPaypalHistory[index]['price'],
          subscriptionFrom: userPaypalHistory[index]['subscription_from'],
          subscriptionTo: userPaypalHistory[index]['subscription_to'],
          packageId: userPaypalHistory[index]['package_id'],
          paymentMethod: userPaypalHistory[index]['method'],
          createdDate: userPaypalHistory[index]['created_at'],
          planName: List.generate(userPaypalHistory[index]['plan'] != null? userPaypalHistory[index]['plan'].length : 0, (int index1){
  //          print("plans ${userPaypalHistory[index]['plan']['name']}");
            return userPaypalHistory[index]['plan']['name'];
          }),
          currency: List.generate(userPaypalHistory[index]['plan'] != null? userPaypalHistory[index]['plan'].length : 0, (int index1){
  //          print("plans ${userPaypalHistory[index]['plan']['name']}");
            return userPaypalHistory[index]['plan']['currency'];
          }),
        );
      });
    }
}

