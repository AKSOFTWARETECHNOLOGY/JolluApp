import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_hour/loading/loading_screen.dart';
import 'package:next_hour/home.dart';

import 'package:next_hour/page_home.dart';

void main() {
  runApp(
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jollu Original',
        home: LoadingScreen(),
        theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blue[800],
          accentColor: Color.fromRGBO(125,183,91, 1.0),
        ),
      )
  );
}


