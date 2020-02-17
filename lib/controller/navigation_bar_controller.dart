import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_hour/page_home.dart';
import 'package:next_hour/ui/custom_drawer.dart';
import 'package:next_hour/ui/my_list.dart';
import 'package:next_hour/ui/search.dart';

class BottomNavigationBarController extends StatefulWidget {
  BottomNavigationBarController({this.pageInd});
  final pageInd;
  final List<Widget> pages = [
    PageHome(
      key: PageStorageKey('Page1'),
    ),
    SearchResultList(
      key: PageStorageKey('Page2'),
    ),
    MyListPage(
      key: PageStorageKey('Page3'),
    ),
    CustomDrawer(
      key: PageStorageKey('Page4'),
    )
  ];
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {

  int _selectedIndex;
  @override
  void initState() {

    super.initState();
    _selectedIndex = widget.pageInd != null ? widget.pageInd : 0;
  }

//  Bottom navigation bar
  Widget _bottomNavigationBar(int selectedIndex) {return CupertinoTabBar(
    activeColor: Colors.white,
    iconSize: 25,
    onTap: (int index) =>
        setState(() => _selectedIndex = index),
    currentIndex: selectedIndex,
    items: [
      BottomNavigationBarItem(title: Text("Home"), icon: Icon(Icons.home)),
      BottomNavigationBarItem(
          title: Text("Search"), icon: Icon(Icons.search)),
      BottomNavigationBarItem(
          title: Text("Wishlist"), icon: Icon(Icons.favorite_border)),
      BottomNavigationBarItem(title: Text('Menu'), icon: Icon(Icons.menu)),
    ],
    backgroundColor: Color.fromRGBO(20, 20, 20, 1.0),
  );}

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        child: Scaffold(
          bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
            body: IndexedStack(
              index: _selectedIndex,
              children: widget.pages,
            )
        ),
        onWillPop: onWillPopS);
  }
}

// Handle back press to exit
Future<bool> onWillPopS() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: "Press again to exit.");
    return Future.value(false);
  }
  return SystemNavigator.pop();
}
