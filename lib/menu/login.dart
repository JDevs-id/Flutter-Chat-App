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
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus loginStatus = LoginStatus.notSignIn;
  TextEditingController contUser = TextEditingController();
  TextEditingController contPass = TextEditingController();
  DateTime dateTimeNow = DateTime.now();
  

  String msg = "";

  var status;
  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      status = preferences.getString("status");

      loginStatus =
          status == "login" ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void savePrefs(String status, String username, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString("status", "login");
      pref.setString("username", contUser.text);
      pref.setString("password", contPass.text);
      print(pref.getString("status"));
      print(pref.getString("username"));
      print(pref.getString("password"));
    });
  }

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.clear();
      loginStatus = LoginStatus.notSignIn;
    });
  }

  void loginAuth() async {
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
        loginStatus = LoginStatus.signIn;
        savePrefs("login", contUser.text, contPass.text);
        Navigator.of(context).pushReplacement(PageRouteTransition(
            builder: (context) => Home(
                  dateTimeNow: dateTimeNow,
                  signOut: signOut,
                )));
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
    switch (loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                  labelStyle: TextStyle(color: PrimaryColor),
                                  hintText: "Input your username",
                                  hintStyle: TextStyle(
                                      color: PrimaryColor.withOpacity(0.5)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              PrimaryColor.withOpacity(0.5)))),
                            ),
                            Stack(
                              children: <Widget>[
                                TextField(
                                  obscureText: showPass,
                                  controller: contPass,
                                  style: TextStyle(color: PrimaryColor),
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(showPass == true
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          togglePassword();
                                        },
                                      ),
                                      labelText: "Password",
                                      labelStyle:
                                          TextStyle(color: PrimaryColor),
                                      hintText: "Input your password",
                                      hintStyle: TextStyle(
                                          color: PrimaryColor.withOpacity(0.5)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: PrimaryColor.withOpacity(
                                                  0.4)))),
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
                                      SystemChrome.setEnabledSystemUIOverlays(
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
                                    fontSize:
                                        MediaQuery.of(context).size.width *
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
        break;
      case LoginStatus.signIn:
        return Home(
          dateTimeNow: dateTimeNow,
          signOut: signOut,
        );
        break;
      default:
        return Scaffold(
            backgroundColor: PrimaryColor,
            body: Center(child: CircularProgressIndicator()));
    }
  }
}
