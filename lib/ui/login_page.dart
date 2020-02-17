import 'package:flutter/material.dart';
import 'package:next_hour/ui/login.dart';
class LoginPage  extends StatefulWidget {
  @override
  _LoginPageState  createState() => new _LoginPageState ();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoginForm()
    );
  }
}