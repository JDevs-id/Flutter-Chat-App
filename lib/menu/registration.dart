import 'package:UserManagement/global/behavior.dart';
import 'package:UserManagement/global/color.dart';
import 'package:UserManagement/global/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController contUsername = TextEditingController();
  TextEditingController contPassword = TextEditingController();
  TextEditingController contRePassword = TextEditingController();

  void addUser() {
    var url = "$BASE_URL/addUser.php";
    if (contPassword.text == contRePassword.text) {
      http.post(url, body: {
        "username": contUsername.text,
        "password": contPassword.text,
        "repassword": contRePassword.text,
        "status": "logout",
      });
      contUsername.text = "";
      contPassword.text = "";
      contRePassword.text = "";
      Navigator.pop(context);
    } else {
      showToastAlert("Your password and repeat password is not same!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Icon(
                    Icons.person_add,
                    color: SecondaryColor.withOpacity(0.3),
                    size: MediaQuery.of(context).size.width * 0.9,
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TextField(
                    controller: contUsername,
                    style: TextStyle(color: SecondaryColor),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(color: SecondaryColor),
                        hintText: "Input username",
                        hintStyle:
                            TextStyle(color: SecondaryColor.withOpacity(0.5)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: SecondaryColor.withOpacity(0.8)))),
                  ),
                  TextField(
                    obscureText: true,
                    controller: contPassword,
                    style: TextStyle(color: SecondaryColor),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: SecondaryColor),
                        hintText: "Input password",
                        hintStyle:
                            TextStyle(color: SecondaryColor.withOpacity(0.5)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: SecondaryColor.withOpacity(0.5)))),
                  ),
                  TextField(
                    obscureText: true,
                    controller: contRePassword,
                    style: TextStyle(color: SecondaryColor),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: InputDecoration(
                      labelText: "Repeat Password",
                      labelStyle: TextStyle(color: SecondaryColor),
                      hintText: "Repeat your password",
                      hintStyle:
                          TextStyle(color: SecondaryColor.withOpacity(0.5)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: SecondaryColor.withOpacity(0.2))),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: SecondaryColor,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: PrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            SystemChrome.setEnabledSystemUIOverlays(
                                [SystemUiOverlay.bottom]);
                            addUser();
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}