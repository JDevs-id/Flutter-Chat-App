import 'package:UserManagement/global/color.dart';
import 'package:UserManagement/global/url.dart';
import 'package:UserManagement/menu/login.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({this.signOut, this.dateTimeNow});
  final VoidCallback signOut;
  final dateTimeNow;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String status = "", username = "", password = "";

  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      status = pref.getString("status");
      username = pref.getString("username");
      password = pref.getString("password");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('HH:mm dd/MM/yyyy').format(widget.dateTimeNow);
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Stack(
        children: <Widget>[
          Center(
              child: Text(
            "Welcome $username",
            style:
                TextStyle(color: SecondaryColor, fontWeight: FontWeight.bold),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: ThirdColor.withOpacity(0.3),
              height: MediaQuery.of(context).size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: <Widget>[
                          Text("Login at ",
                              style: TextStyle(
                                  color: SecondaryColor)),
                          Text(
                            "$formattedDate",
                            style: TextStyle(
                                color: SecondaryColor),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
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
                          "username": username,
                          "status": "logout",
                        });
                        signOut();
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
