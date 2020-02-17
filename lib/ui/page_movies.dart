import 'package:flutter/material.dart';

class MoviesPage extends StatefulWidget {
  MoviesPage({Key key}) : super(key: key);

  @override
  _MoviesPageState createState() => new _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {

//Title text movies
  Widget titleText(){
    return Column(
      children: [
        Text("Movies", style: Theme.of(context).textTheme.caption),
      ],
    );
  }

// Build method
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: titleText(),
    );
  }
}
