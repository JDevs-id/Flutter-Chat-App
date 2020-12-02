import 'dart:convert';
import 'dart:io';

import 'package:user_management/global/color.dart';
import 'package:user_management/global/url.dart';
import 'package:user_management/menu/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:route_transitions/route_transitions.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/menu/messaging/inbox.dart';
import 'package:user_management/menu/messaging/message.dart';

class Home extends StatefulWidget {
  Home({this.signOut, this.dateTimeNow});
  final VoidCallback signOut;
  final dateTimeNow;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var status, username, password, index, id, sessions;
  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      status = pref.getString("status");
      username = pref.getString('username');
      password = pref.getString('password');
      index = pref.getInt('index');
      id = pref.getInt('id');
      sessions = pref.getInt('sessions');
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Future<List> getUser() async {
    final response = await http.get("$BASE_URL/getUsers.php");
    return json.decode(response.body);
  }

  void signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('HH:mm dd/MM/yyyy').format(widget.dateTimeNow);
    //print("getPrefs :$index, $id, $username, $password, $status, $sessions");
    return FutureBuilder<List>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return int.parse(snapshot.data[index]['sessions']) == sessions
              ? Scaffold(
                  backgroundColor: PrimaryColor,
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: FloatingActionButton(
                        backgroundColor: SecondaryColor,
                        child: Icon(Icons.message, color: PrimaryColor),
                        onPressed: () => Navigator.of(context).push(
                              PageRouteTransition(
                                  builder: (context) => Message(),
                                  animationType: AnimationType.fade),
                            )),
                  ),
                  body: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome $username",
                            style: TextStyle(
                                color: SecondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              color: SecondaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.notifications,
                                        color: PrimaryColor),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text("INBOX",
                                            style: TextStyle(
                                                color: PrimaryColor,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              onPressed: () => Navigator.of(context).push(
                                PageRouteTransition(
                                    builder: (context) => Inbox(),
                                    animationType: AnimationType.fade),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                          style:
                                              TextStyle(color: SecondaryColor)),
                                      Text(
                                        "$formattedDate",
                                        style: TextStyle(color: SecondaryColor),
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
                                          style:
                                              TextStyle(color: SecondaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    http.post("$BASE_URL/editStatus.php",
                                        body: {
                                          "username": username,
                                          "status": "logout",
                                          "sessions": sessions.toString(),
                                        });
                                    signOut();
                                    print(
                                        "getPrefs SignOut :$index, $id, $username, $password, $status, $sessions");
                                    Navigator.of(context).pushReplacement(
                                        PageRouteTransition(
                                            builder: (context) => Login()));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Scaffold(
                  backgroundColor: PrimaryColor,
                  body: Center(
                      child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    title: Text("Login Alert!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: FourthColor)),
                    content: Text(
                      "Your account is signed in on another device! Do you want to log in again with this device?",
                      textAlign: TextAlign.justify,
                    ),
                    actions: <Widget>[
                      RaisedButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: SecondaryColor),
                        ),
                        color: FourthColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          signOut();
                          Navigator.of(context).pushReplacement(
                              PageRouteTransition(
                                  builder: (context) => Login()));
                        },
                      ),
                      RaisedButton(
                        child: Text(
                          "No",
                          style: TextStyle(color: SecondaryColor),
                        ),
                        color: PrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          exit(0);
                        },
                      ),
                    ],
                  )));
        }
        return Scaffold(
            backgroundColor: PrimaryColor,
            body: Center(
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
                    "loading data ...",
                    style: TextStyle(color: SecondaryColor),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
