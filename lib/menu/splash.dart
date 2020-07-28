import 'dart:async';

import 'package:UserManagement/global/color.dart';
import 'package:UserManagement/menu/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:route_transitions/route_transitions.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).push(PageRouteTransition(
            builder: (context) => Login(), animationType: AnimationType.fade)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                "Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                    color: SecondaryColor),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                  Text(
                    "Loading Data ...",
                    style: TextStyle(color: SecondaryColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
