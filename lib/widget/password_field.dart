import 'package:flutter/material.dart';

class HiddenPasswordField extends StatefulWidget {
  final _passwordController;
  final hintText;
  HiddenPasswordField(this._passwordController,this.hintText);
  @override
  _HiddenPasswordFieldState createState() => _HiddenPasswordFieldState();
}

class _HiddenPasswordFieldState extends State<HiddenPasswordField> {
  bool _isHidden = true;

// Toggle for visibility
  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }

//  Password TextFormField
  Widget passwordTextFormField(){
    return TextFormField(
      controller: widget._passwordController,
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: Color.fromRGBO(34, 34, 34, 0.4), fontSize: 18),
        suffixIcon: widget.hintText == "Enter your password" ? IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden ? Text("Show",style: TextStyle(fontSize: 10.0, color: Colors.black),) : Text("Hide",style: TextStyle(fontSize: 10.0, color: Colors.black),),
        ) : null,
      ),
      style: TextStyle(
          color: Color.fromRGBO(34, 34, 34, 0.7), fontSize: 18),
      validator: (val) {
        if (val.length < 6) {
          if (val.length == 0) {
            return 'Password can not be empty';
          } else {
            return 'Password too short';
          }
        } else {
          return null;
        }
      },
      onSaved: (val) => widget._passwordController.text = val,
      obscureText: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0.0,
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Container(
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
                  passwordTextFormField(),
                  _isHidden == false ? Container(
                      height: 12.0,
                      child: TextField(
                          controller: widget._passwordController,
                          readOnly: true,
                          style: TextStyle(color: Color.fromRGBO(34, 34, 34, 0.8),fontSize: 12.0),
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.amber,

                          )
                      )
                  )
                      :  SizedBox(
                    height: 0.0,
                  ),
                ],
              )
          ),
        )
    );
  }
}
