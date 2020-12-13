import 'dart:convert';

import 'package:user_management/global/behavior.dart';
import 'package:user_management/global/color.dart';
import 'package:user_management/global/url.dart';
import 'package:user_management/menu/home.dart';
import 'package:user_management/menu/registration.dart';
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
  SharedPreferences pref;
  List dataUser = [];

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

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    loginStatus = LoginStatus.notSignIn;
  }

  void loginAuth() async {
    final response = await http.post("$BASE_URL/loginAuth.php", body: {
      "username": contUser.text,
      "password": contPass.text,
    });

    dataUser = json.decode(response.body);

    void savePrefs(
        String user, String pass, String stat, int sess, String accStat) async {
      pref = await SharedPreferences.getInstance();
      setState(() {
        pref.setString("username", user);
        pref.setString("password", pass);
        pref.setString("status", stat);
        pref.setInt("sessions", sess);
        pref.setString("account_status", stat);
      });
    }

    if (dataUser.length == 0) {
      setState(() {
        showToastAlert("Login Failed! Check your username and password!");
      });
    } else {
      if (dataUser[0]['status'] == "login") {
        AlertDialog _loginAlert = AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Text("Login Alert!",
              textAlign: TextAlign.center,
              style: TextStyle(color: FourthColor)),
          content: ScrollConfiguration(
            behavior: NoScrollGrow(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Are you sure you want to log in to this device? Your account is still signed in on another device!",
                    textAlign: TextAlign.justify,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Note: Your account on other devices will automatically sign out if you choose to sign in to this device",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 8, color: FourthColor),
                    ),
                  ),
                ],
              ),
            ),
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
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
                loginStatus = LoginStatus.signIn;
                savePrefs(contUser.text, contPass.text, "login",
                    int.parse(dataUser[0]['sessions']) + 1, "enable");
                http.post("$BASE_URL/editStatus.php", body: {
                  "username": contUser.text,
                  "status": "login",
                  "sessions":
                      (int.parse(dataUser[0]['sessions']) + 1).toString()
                });
                Navigator.of(context).pushReplacement(PageRouteTransition(
                    builder: (context) =>
                        Home(dateTimeNow: dateTimeNow, signOut: signOut)));
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
                Navigator.pop(context);
              },
            ),
          ],
        );

        showDialog(
          context: context,
          builder: (context) => _loginAlert,
          barrierDismissible: false,
        );
      }
      if (dataUser[0]['account_status'] == "disable") {
        AlertDialog _statusAlert = AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Text("Login Alert!",
              textAlign: TextAlign.center,
              style: TextStyle(color: FourthColor)),
          content: ScrollConfiguration(
            behavior: NoScrollGrow(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Your account is disabled!",
                    textAlign: TextAlign.justify,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Contact administrator to enable your account or create some new account!",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 8, color: FourthColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text(
                "OK",
                style: TextStyle(color: SecondaryColor),
              ),
              color: PrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );

        showDialog(
          context: context,
          builder: (context) => _statusAlert,
          barrierDismissible: false,
        );
      } else if (dataUser[0]['status'] == "logout" &&
          dataUser[0]['account_status'] == "enable") {
        loginStatus = LoginStatus.signIn;
        savePrefs(contUser.text, contPass.text, "login",
            (int.parse(dataUser[0]['sessions'])) + 1, "enable");
        http.post("$BASE_URL/editStatus.php", body: {
          "username": contUser.text,
          "status": "login",
          "sessions": (int.parse(dataUser[0]['sessions']) + 1).toString()
        });
        Navigator.of(context).pushReplacement(PageRouteTransition(
            builder: (context) =>
                Home(dateTimeNow: dateTimeNow, signOut: signOut)));
      }
    }
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
                padding: const EdgeInsets.only(top: 30, left: 20),
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
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
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
                            TextField(
                              obscureText: showPass,
                              controller: contPass,
                              textInputAction: TextInputAction.go,
                              onSubmitted: (_) {
                                SystemChrome.setEnabledSystemUIOverlays(
                                    [SystemUiOverlay.bottom]);
                                FocusScope.of(context).unfocus();
                                loginAuth();
                              },
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
                                  labelStyle: TextStyle(color: PrimaryColor),
                                  hintText: "Input your password",
                                  hintStyle: TextStyle(
                                      color: PrimaryColor.withOpacity(0.5)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              PrimaryColor.withOpacity(0.4)))),
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
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
                                      FocusScope.of(context).unfocus();
                                      loginAuth();
                                    }),
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
        return Home(dateTimeNow: dateTimeNow, signOut: signOut);
        break;
      default:
        return Scaffold(
            backgroundColor: PrimaryColor,
            body: Center(child: CircularProgressIndicator()));
    }
  }
}
