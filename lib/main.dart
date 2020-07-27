import 'dart:async';
import 'dart:convert';

import 'package:UserManagement/global/url.dart';
import 'package:UserManagement/menu/home.dart';
import 'package:UserManagement/menu/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamController streamController = StreamController();
  DateTime loginTime = DateTime.now();

  Future getData() async {
    final response = await http.get("$BASE_URL/getUser.php");
    var dataUser = json.decode(response.body);
    streamController.add(dataUser);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        title: 'User Management',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder()
            })),
        home: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? Home(
                      user: snapshot.data[0]['username'],
                      loginTime: loginTime,
                    )
                  : Login();
            }));
  }
}
