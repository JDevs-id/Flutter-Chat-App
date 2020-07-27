import 'package:UserManagement/global/behavior.dart';
import 'package:UserManagement/global/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController contUser = TextEditingController();
  TextEditingController contPass = TextEditingController();

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  String msg = "";
  loginAuth() {}

  bool showPass = true;
  void togglePassword() {
    setState(() {
      showPass = !showPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
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
                onTap: () {},
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
                                        color: PrimaryColor.withOpacity(0.5)))),
                          ),
                          Stack(
                            children: <Widget>[
                              TextField(
                                obscureText: showPass,
                                controller: contPass,
                                style: TextStyle(color: PrimaryColor),
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: PrimaryColor),
                                    hintText: "Input your password",
                                    hintStyle: TextStyle(
                                        color: PrimaryColor.withOpacity(0.5)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: PrimaryColor.withOpacity(
                                                0.4)))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 35, right: 10),
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
                                      borderRadius: BorderRadius.circular(10)),
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
                                      MediaQuery.of(context).size.width * 0.03),
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
      ),
    );
  }
}
