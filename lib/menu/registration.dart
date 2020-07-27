import 'package:UserManagement/global/color.dart';
import 'package:UserManagement/menu/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:route_transitions/route_transitions.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController contUsername = TextEditingController();
  TextEditingController contPassword = TextEditingController();
  TextEditingController contRePassword = TextEditingController();

  void addUser() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
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
                  hintStyle: TextStyle(color: SecondaryColor.withOpacity(0.5)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: SecondaryColor.withOpacity(0.8)))),
            ),
            TextField(
              controller: contPassword,
              style: TextStyle(color: SecondaryColor),
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: SecondaryColor),
                  hintText: "Input password",
                  hintStyle: TextStyle(color: SecondaryColor.withOpacity(0.5)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: SecondaryColor.withOpacity(0.5)))),
            ),
            TextField(
              controller: contRePassword,
              style: TextStyle(color: SecondaryColor),
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              decoration: InputDecoration(
                labelText: "Repeat Password",
                labelStyle: TextStyle(color: SecondaryColor),
                hintText: "Repeat your password",
                hintStyle: TextStyle(color: SecondaryColor.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: SecondaryColor.withOpacity(0.2))),
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
                          color: PrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      SystemChrome.setEnabledSystemUIOverlays(
                          [SystemUiOverlay.bottom]);
                      addUser();
                      Navigator.of(context).push(PageRouteTransition(
                          builder: (context) => Login(),
                          animationType: AnimationType.fade));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
