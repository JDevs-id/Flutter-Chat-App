import 'dart:convert';

import 'package:UserManagement/global/behavior.dart';
import 'package:UserManagement/global/color.dart';
import 'package:UserManagement/global/url.dart';
import 'package:UserManagement/menu/home.dart';
import 'package:UserManagement/menu/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:route_transitions/route_transitions.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController contUser = TextEditingController();
  TextEditingController contPass = TextEditingController();
  DateTime loginTime = DateTime.now();

  String msg = "";

  Future<List> getUser() async {
    final response = await http.get("$BASE_URL/getUser.php");
    var dataUser = json.decode(response.body);
    print(dataUser);
    return dataUser;
  }

  Future<List> loginAuth() async {
    final response = await http.post("$BASE_URL/loginAuth.php", body: {
      "username": contUser.text,
      "password": contPass.text,
    });

    var dataUser = json.decode(response.body);
    if (dataUser.length == 0) {
      setState(() {
        msg = "Login Failed!\nCheck your username and password!";
      });
    } else {
      if (dataUser[0]['status'] == "login") {
        showToastAlert("This account is still used in other device!");
        http.post("$BASE_URL/editStatus.php", body: {
          "username": contUser.text,
          "status": "logout",
        });
      } else if (dataUser[0]['status'] == "logout") {
        msg = "";
        http.post("$BASE_URL/editStatus.php", body: {
          "username": contUser.text,
          "status": "login",
        });
        Navigator.of(context).pushReplacement(PageRouteTransition(
            builder: (context) => Home(user: dataUser, loginTime: loginTime)));
      }
    }

    return dataUser;
  }

  bool showPass = true;
  void togglePassword() {
    setState(() {
      showPass = !showPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getUser(),
        builder: (context, snapshot) {
          return snapshot?.data?.isNotEmpty ?? false
              ? Home(
                  user: snapshot.data,
                  loginTime: loginTime,
                )
              : Scaffold(
                  backgroundColor: PrimaryColor,
                  body: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                color: SecondaryColor,
                                size: MediaQuery.of(context).size.width * 0.055,
                              ),
                              Text(
                                "Sign Up",
                                style: TextStyle(color: SecondaryColor),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(PageRouteTransition(
                                builder: (context) => Registration(),
                                animationType: AnimationType.fade));
                          },
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Icon(
                              Icons.supervised_user_circle,
                              color: SecondaryColor,
                              size: MediaQuery.of(context).size.width * 0.9,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 40),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                                color: SecondaryColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ScrollConfiguration(
                                behavior: NoScrollGrow(),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    TextField(
                                      controller: contUser,
                                      style: TextStyle(color: PrimaryColor),
                                      decoration: InputDecoration(
                                          labelText: "Username",
                                          labelStyle:
                                              TextStyle(color: PrimaryColor),
                                          hintText: "Input your username",
                                          hintStyle: TextStyle(
                                              color: PrimaryColor.withOpacity(
                                                  0.5)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      PrimaryColor.withOpacity(
                                                          0.5)))),
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        TextField(
                                          obscureText: showPass,
                                          controller: contPass,
                                          style: TextStyle(color: PrimaryColor),
                                          decoration: InputDecoration(
                                              labelText: "Password",
                                              labelStyle: TextStyle(
                                                  color: PrimaryColor),
                                              hintText: "Input your password",
                                              hintStyle: TextStyle(
                                                  color:
                                                      PrimaryColor.withOpacity(
                                                          0.5)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: PrimaryColor
                                                              .withOpacity(
                                                                  0.4)))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 35, right: 10),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: InkWell(
                                              child: Icon(showPass == true
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onTap: () {
                                                togglePassword();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            color: PrimaryColor,
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: SecondaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              SystemChrome
                                                  .setEnabledSystemUIOverlays(
                                                      [SystemUiOverlay.bottom]);
                                              loginAuth();
                                            }),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        msg,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: FourthColor.withOpacity(0.8),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        });
  }
}
