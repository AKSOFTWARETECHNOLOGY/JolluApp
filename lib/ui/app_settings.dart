import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/ui/no_network.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


bool isSwitched = true;
class AppSettingsPage extends StatefulWidget {

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettingsPage> {
  Connectivity connectivity;
  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult> subscription;
  var _connectionStatus = 'Unknown';

  Widget appBar() {
      return AppBar(
        title: Text("App Settings",style: TextStyle(fontSize: 16.0),),
        centerTitle: true,

        backgroundColor:
        Color.fromRGBO(34,34,34, 1.0).withOpacity(0.98),
      );
  }

  Widget wifiTitleText() {
    return Text(
      "Wi-Fi Only",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
    );
  }

  Widget leadingWifiListTile() {
    return Container(
    padding: EdgeInsets.only(right: 20.0),
    decoration: new BoxDecoration(
        border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.white24))),
    child: Icon(FontAwesomeIcons.signal, color: Colors.white, size: 20.0,),
  );
  }

  Widget wifiSubtitle() {
    return Container(
      height: 40.0,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text("Play video only when connected to wi-fi.",
                    style: TextStyle(color: Colors.white, fontSize: 12.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget wifiSwitch() {
      return Switch(
          value: boolValue,
          onChanged: (value) {
            addBoolToSF(value);
            print(value);
          },
          activeTrackColor: Color.fromRGBO(125, 183, 91, 1.0),
          activeColor: Color.fromRGBO(237, 237, 237, 1.0),
        );
    }

//    Widget used to create ListTile to show wi-fi status
  Widget makeListTile1() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: leadingWifiListTile(),
      title: wifiTitleText(),
      subtitle: wifiSubtitle(),
      trailing: wifiSwitch(),
    );
  }

  Widget scaffold() {
    return Scaffold(
        appBar: appBar(),
        body: Container(
            child: Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(20, 20, 20, .9)
                ),
                child: makeListTile1(),
              ),
            )
        )
    );
  }

//  Used to save value to shared preference of wi-fi switch
  addBoolToSF(value) async {
      print("va $value");
      prefs = await SharedPreferences.getInstance();
      prefs.setBool('boolValue', value);
    }

//  Used to get saved value from shared preference of wi-fi switch
  getValuesSF() async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        boolValue = prefs.getBool('boolValue');
      });

    }
    @override
    void initState() {
      // TODO: implement initState
      super.initState();

      isSwitched = true;
      this.getValuesSF();

//    Used to check connection status of use device
    connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(_connectionStatus);

          checkConnectionStatus = result.toString();
          if (result == ConnectivityResult.wifi) {
            setState(() {
              _connectionStatus='Wi-Fi';
              isSwitched=true;
            });

          }else if( result == ConnectivityResult.mobile){
            setState(() {
              _connectionStatus='Mobile';
              isSwitched=false;
            });
          }
          else if( result == ConnectivityResult.none){
            var router = new MaterialPageRoute(
                builder: (BuildContext context) => new NoNetwork());
            Navigator.of(context).push(router);
          }
        });
    }

    @override
    Widget build(BuildContext context) {
      if(boolValue == null){
        boolValue = false;
      }
      return scaffold();
    }
  }
