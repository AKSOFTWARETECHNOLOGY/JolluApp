import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

File jsonFile;
Directory dir;
String fileName = "userJSON.json";
bool fileExists = false;
Map<dynamic, dynamic> fileContent;


String name='';
String email='';
String mobile='';
String dob='';
String address='';
String role='';
String nameInitial='';
String message='';
String fullData='';
// ignore: non_constant_identifier_names
String created_at='';
String activePlan='';
String activeStatus='';
String expiryDate='';
String subscriptionHistory='';
String subNamesHistory='';


int status;
int movieDataLength;
int menuDataListLength;
bool boolValue;
SharedPreferences prefs;
DateTime currentDate;

//  For user profile, plan subscription details and payment history details.
var userId;
var dataUser;
var userDetail;
var userRole;
var userName;
var userEmail;
var userMobile;
var userDOB;
var userImage;
var userCreatedAt;
var userActivePlan;
var userPaypalHistory;
var userStripeHistory;
var userActiveStatus;
var userExpiryDate;
var userSubscriptionHistory;
var userSubNamesHistory;
var userPlanStart;
var userPlanEnd;
var userPaymentType;
var userPaypalPayId;
var stripeCustomerId;
var difference;
var faqApiData;
var userProfileApiData;
var dateDiff;
var remainingDays;

//  For slider, movies and tv series
var sliderResponseData;
var mainData;
var topMData;
var showPaymentGateway;
int menuList;
var menuId;
var newVideosList1;
var newVideosListG;
var episodesList;
var code;
var seasonEpisodeData;
var checkConnectionStatus;


//  For payment gateways stripe, braintree and paystack
var ser;
var stripePayment;
var stripeData;
var stripeKey;
var stripePass;
var paypalPayment;
var payuPayment;
var paytmPayment;
var paystackPayment;
var braintreePayment;
var btreePayment;
var braintreeClientNonce;
var payStackKey;
var menuDataResponse;
var showWatchlist;
var genreId;
var userWatchListOld;
var homeApiResponseData;
var loginImageData;
var loginConfigData;
var homeDataBlocks;
var faqHelp;


//  Used for movies, slider and genres
List movieData;
List genreData;
List mDataCount;
List sliderData;
List topMenuData;
List menuDataArray;

List allDataList= new List();


//  Used for search page
List searchIds = new List();
List searchIds2 = new List();


//  Used for watchlist page
List userWatchList = new List();
Color greenPrime = const Color.fromRGBO( 125, 183, 91, 1.0);