import 'package:flutter/material.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/model/stripe_history_model.dart';
import 'package:next_hour/utils/seperator2.dart';
import 'package:next_hour/widget/blank_history.dart';

class StripePaymentHistory extends StatefulWidget {
  final int index;
  StripePaymentHistory({Key key,this.index}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StripePaymentHistoryState();
  }
}

class StripePaymentHistoryState extends State<StripePaymentHistory> {
  List<StripeHistoryModel> itemList1;

  List<StripeHistoryModel> _stripeHistoryList() {
    return List<StripeHistoryModel>.generate(userStripeHistory == null ? 0 : userStripeHistory.length, (int index){
      return new StripeHistoryModel(
        id: userStripeHistory[index]['id'],
        userId: userStripeHistory[index]['user_id'],
        name: userStripeHistory[index]['name'],
        stripeId: userStripeHistory[index]['stripe_id'],
        stripePlan: userStripeHistory[index]['stripe_plan'],
        subscriptionFrom: userStripeHistory[index]['subscription_from'],
        subscriptionTo: userStripeHistory[index]['subscription_to'],
        subCreatedDate: userStripeHistory[index]['created_at'],
//        subCurrency: userStripeHistory[index]['created_at'],
        subAmount: userStripeHistory[index]['amount'],
      );
    });
  }

  List <Card> _buildCards(int count) {

    for(var j=0; j<itemList1.length; j++){

      List<Card> cards = List.generate(
        count,
            (j) => Card(
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
                          stripePlanName(itemList1[j].name),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                                child: new Separator2(),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                ),
                                subsCreatedDate(itemList1[j].subCreatedDate),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          child: Text(
                                            itemList1[j].subAmount.toString() +' ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600),
                                          )
                                      ),
                                      SizedBox(
                                        height: 3.0,
                                      ),
                                      subscriptionFromTo(itemList1[j].subscriptionTo,itemList1[j].subscriptionTo),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          stripeId(itemList1[j].stripeId),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      );

      return cards;
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stripeHistoryList();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget appBar() {
    return AppBar(
      title: Text("Stripe Payment History", style: TextStyle(fontSize: 16.0),),
      centerTitle: true,
      backgroundColor:
      Color.fromRGBO(34, 34, 34, 1.0).withOpacity(0.98),
    );
  }

  Widget stripeId(stripePaymentId){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
          ),
          Expanded(
            child: stripePaymentId !=null ? Text(
              'Transaction ID:' + '\n' + stripePaymentId,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  height: 1.3),
            ) : Text(
              'Transaction ID:' + '\n' + 'N/A',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget subscriptionFromTo(subFrom, subTo){
    return Container(
      child: subFrom != null &&  subTo != null ? Text(
        'From' +
            ' ' +
            subFrom +
            ' ' +
            'To' +
            '\n' +
            subTo,
        style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
            letterSpacing: 0.8,
            height: 1.3,
            fontWeight: FontWeight.w500),
      ) : Text(
        'From' +
            ' ' +
            'N/A' +
            ' ' +
            'To' +
            '\n' +
            'N/A',
        style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
            letterSpacing: 0.8,
            height: 1.3,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget subsCreatedDate(subscriptionCreatedDate){
    return Expanded(
      flex: 2,
      child: subscriptionCreatedDate != null ? Text(
        subscriptionCreatedDate + ' via ' + '\n' + 'Stripe',
        style: TextStyle(color: Colors.white, fontSize: 12.0),)
          : Text(
        'N/A' + ' via ' + '\n' + 'Stripe',
        style:
        TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }

  Widget stripePlanName(stripePlan){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0),
        ),
        Expanded(child:
        stripePlan != null ? Text(
          stripePlan.toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600),
        ) : Text(
          'N/A',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600),
        ),
        ),
      ],
    );
  }

  Widget scaffoldBody(){
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: userStripeHistory != null ? Column(
            children: _buildCards(itemList1.length) ,
          ) : BlankHistoryContainer(),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    itemList1 = _stripeHistoryList();
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            appBar: appBar(),
            backgroundColor: Color.fromRGBO(34,34,34, 0.0),
            body:scaffoldBody()
        )
    );
  }

}
