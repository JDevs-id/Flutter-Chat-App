import 'package:flutter/material.dart';
import 'package:user_management/global/color.dart';

class Message extends StatefulWidget {
  Message({Key key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Center(
        child: Text(
          "Menu Messaging",
          style: TextStyle(color: SecondaryColor),
        ),
      ),
    );
  }
}
