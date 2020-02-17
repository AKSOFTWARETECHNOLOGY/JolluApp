import 'package:meta/meta.dart';

class LoginHome {
  LoginHome({
    @required this.title,
    @required this.welcomeTitle,
    this.welcomeDescription,
    this.backgroundImage,
  });

  final String title;
  final String welcomeTitle;
  final String welcomeDescription;
  final String backgroundImage;

}