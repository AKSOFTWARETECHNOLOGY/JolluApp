import 'package:flutter/material.dart';


//  For confirm password this widget  will called.
class ConfirmPasswordField extends StatefulWidget {
  final _passwordController;
  final _repeatPasswordController;
  ConfirmPasswordField(this._passwordController,this._repeatPasswordController);
  @override
  _ConfirmPasswordFieldState createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {

//  TextFormField
  Widget textField(){
    return TextFormField(
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: "Confirm password",
        hintStyle: TextStyle(
            color: Color.fromRGBO(34, 34, 34, 0.4), fontSize: 18),
      ),
      style: TextStyle(
          color: Color.fromRGBO(34, 34, 34, 0.7), fontSize: 18),
      validator: (val) {
        if (val.length < 6) {
          if (val.length == 0) {
            return 'Confirm Password can not be empty';
          } else {
            return 'Password too short';
          }
        } else {
          if(widget._passwordController.text == val){
            return null;
          }else{
            return 'Password & Confirm Password does not match';
          }

        }
      },
      onSaved: (val) => widget._repeatPasswordController.text = val,
      obscureText: true,
    );
  }

//  TextField Container
  Widget fieldContainer(){
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.9),
          offset: Offset(0, 2.0),
          blurRadius: 4.0,
        )
      ]),
      child: Padding(
          padding: EdgeInsets.only(
              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: Column(
            children: <Widget>[
              textField(),

            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0.0,
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: fieldContainer(),
    );
  }
}
