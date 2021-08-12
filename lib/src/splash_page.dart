import 'dart:async';
import 'package:flutter/material.dart';
import 'package:userapp/src/routes/screen_routes.dart';
import 'package:userapp/src/utils/size_config.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double iconSize = 0.0;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        iconSize = 0.2;
      });
    });

    Timer(Duration(seconds: 2), () {
      Navigator.pushNamed(context, ScreenRoute.loginPageRoute);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var width = SizeConfig.screenWidth;
    var height = SizeConfig.screenHeight;
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          width: height! * iconSize,
          height: height * iconSize,
          child: ClipOval(child: Image.asset("assets/images/splash_bg.png")),
        ),
      ),
    );
  }
}
