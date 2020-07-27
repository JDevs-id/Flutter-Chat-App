import 'package:UserManagement/global/color.dart';
import 'package:UserManagement/global/url.dart';
import 'package:UserManagement/menu/login.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  Home({this.user, this.loginTime});
  final String user;
  final loginTime;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Stack(
        children: <Widget>[
          Center(
              child: Text(
            "Welcome ${widget.user}",
            style:
                TextStyle(color: SecondaryColor, fontWeight: FontWeight.bold),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: ThirdColor.withOpacity(0.3),
              height: MediaQuery.of(context).size.height * 0.03,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "${widget.loginTime}",
                        style: TextStyle(
                            color: SecondaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: SecondaryColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Log Out",
                              style: TextStyle(color: SecondaryColor),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        http.post("$BASE_URL/editStatus.php", body: {
                          "username": widget.user,
                          "status": "logout",
                        });
                        Navigator.of(context).pushReplacement(
                            PageRouteTransition(builder: (context) => Login()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
