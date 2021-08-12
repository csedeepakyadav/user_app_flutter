import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userapp/src/routes/screen_routes.dart';
import 'package:userapp/src/splash_page.dart';
import 'package:userapp/src/views/auth/phone_auth_page.dart';
import 'package:userapp/src/views/home_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ScreenRoute.splashPageRoute:
        return MaterialPageRoute(builder: (context) => SplashPage());

      case ScreenRoute.loginPageRoute:
        return MaterialPageRoute(builder: (context) => PhoneAuthPage());

      case ScreenRoute.homePageRoute:
        return MaterialPageRoute(builder: (context) => HomePage());

      default:
        return MaterialPageRoute(builder: (context) => SplashPage());
    }
  }
}
