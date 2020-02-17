import 'package:flutter/material.dart';

class DescriptionText extends StatefulWidget {
  DescriptionText(this.text);

  final String text;

  @override
  _DescriptionTextState createState() => new _DescriptionTextState();
}

class _DescriptionTextState extends State<DescriptionText> {
  bool descTextShowFlag = false;

  Widget descriptionHeader(theme){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                descTextShowFlag = !descTextShowFlag;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                descTextShowFlag
                    ? Text(
                  '',
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.9,
                      color: theme.accentColor
                    // color: Colors.white
                  ),
                )
                    : Text(
                  '',
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.9,
                      color: theme.accentColor
                    // color: Colors.white
                  ),
                ),
                descTextShowFlag
                    ? Icon(
                  Icons.keyboard_arrow_up,
                  size: 18.0,
                  color: theme.accentColor,
                )
                    : Icon(
                  Icons.keyboard_arrow_down,
                  size: 18.0,
                  color: theme.accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    descTextShowFlag = !descTextShowFlag;
                  });
                },
                child: Text(widget.text,
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.9,
                        color: Colors.white
                      // color: Colors.white
                    ),
                    maxLines: descTextShowFlag ? 100 : 2,
                    textAlign: TextAlign.start),
              ),

            ],
          ),
        ),
        // No expand-collapse in this tutorial, we just slap the "more"
        descriptionHeader(theme),
      ],
    );

  }

}
