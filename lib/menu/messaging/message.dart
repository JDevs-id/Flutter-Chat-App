import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_management/global/color.dart';

class Message extends StatefulWidget {
  Message({Key key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    void _send() {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    }

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
                    Icons.message,
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
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(color: SecondaryColor),
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    decoration: InputDecoration(
                        labelText: "to",
                        labelStyle: TextStyle(color: SecondaryColor),
                        hintText: "Input the destination username",
                        hintStyle:
                            TextStyle(color: SecondaryColor.withOpacity(0.5)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: SecondaryColor.withOpacity(0.8)))),
                  ),
                  TextField(
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _send(),
                    maxLines: null,
                    style: TextStyle(color: SecondaryColor),
                    decoration: InputDecoration(
                        labelText: "Message",
                        labelStyle: TextStyle(color: SecondaryColor),
                        hintText: "Input your message",
                        hintStyle:
                            TextStyle(color: SecondaryColor.withOpacity(0.5)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: SecondaryColor.withOpacity(0.8)))),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: SecondaryColor,
                          child: Text(
                            "Send",
                            style: TextStyle(
                                color: PrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _send()),
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
