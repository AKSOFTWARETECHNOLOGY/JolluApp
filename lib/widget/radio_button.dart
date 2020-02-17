import 'package:flutter/material.dart';

//  RadioButton used on login and sign up page
class RadioButtonField extends StatelessWidget {
  final isSelected;
  RadioButtonField(this.isSelected);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.0,
      height: 16.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.black)),
      child: isSelected
          ? Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
        BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      )
          : Container(),
    );
  }
}
