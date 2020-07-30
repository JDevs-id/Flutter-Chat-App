import 'dart:convert';

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
  String status = "logout";
  String sessions = "0";

  Future getUser() async {
    final response = await http.get("$BASE_URL/getUsers.php");
    return json.decode(response.body);
  }

  void addUser() {
    var url = "$BASE_URL/addUser.php";
    if (contPassword.text == contRePassword.text &&
        contUsername.text != "" &&
        contPassword.text != "") {
      http.post(url, body: {
        "username": contUsername.text,
        "password": contPassword.text,
        "status": status,
        "sessions": sessions,
      });
      contUsername.text = "";
      contPassword.text = "";
      contRePassword.text = "";
      showToastAlert("Data is successfully saved!");
      FocusScope.of(context).unfocus();
      Navigator.pop(context);
    } else if (contUsername.text == "" || contPassword.text == "") {
      showToastAlert("Fill all the fields!");
    } else {
      showToastAlert("Your password and repeat password is not same!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          style: TextStyle(color: SecondaryColor),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(color: SecondaryColor),
                              hintText: "Input username",
                              hintStyle: TextStyle(
                                  color: SecondaryColor.withOpacity(0.5)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SecondaryColor.withOpacity(0.8)))),
                        ),
                        TextField(
                          obscureText: true,
                          controller: contPassword,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          style: TextStyle(color: SecondaryColor),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: SecondaryColor),
                              hintText: "Input password",
                              hintStyle: TextStyle(
                                  color: SecondaryColor.withOpacity(0.5)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: SecondaryColor.withOpacity(0.5)))),
                        ),
                        TextField(
                          obscureText: true,
                          controller: contRePassword,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (_) {
                            SystemChrome.setEnabledSystemUIOverlays(
                                [SystemUiOverlay.bottom]);
                            addUser();
                          },
                          style: TextStyle(color: SecondaryColor),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                            labelText: "Repeat Password",
                            labelStyle: TextStyle(color: SecondaryColor),
                            hintText: "Repeat your password",
                            hintStyle: TextStyle(
                                color: SecondaryColor.withOpacity(0.5)),
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
                    "please wait ...",
                    style: TextStyle(color: SecondaryColor),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
