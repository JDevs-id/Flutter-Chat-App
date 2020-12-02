import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_management/global/behavior.dart';
import 'package:user_management/global/color.dart';

class DetailInbox extends StatefulWidget {
  @override
  _DetailInboxState createState() => _DetailInboxState();
}

class _DetailInboxState extends State<DetailInbox> {
  @override
  Widget build(BuildContext context) {
    void _send() {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      backgroundColor: PrimaryColor,
      /*
      floatingActionButton: FloatingActionButton(
        backgroundColor: SecondaryColor,
        child: Icon(Icons.add_comment, color: PrimaryColor),
        onPressed: () => Navigator.of(context).push(
          PageRouteTransition(
              builder: (context) => Message(),
              animationType: AnimationType.fade),
        ),
      ),*/
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: NoScrollGrow(),
            child: ListView(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07, bottom: 90),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 60, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: SecondaryColor.withOpacity(0.75),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        style: TextStyle(color: PrimaryColor),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: SecondaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        style: TextStyle(color: SecondaryColor),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              color: SecondaryColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Center(
                  child: Text(
                "Sender",
                style:
                    TextStyle(color: PrimaryColor, fontWeight: FontWeight.w900),
              ))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: SecondaryColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) {
                      _send();
                    },
                    maxLines: null,
                    style: TextStyle(color: PrimaryColor),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send, color: PrimaryColor),
                          onPressed: () {
                            _send();
                          },
                        ),
                        hintText: "Replay message",
                        hintStyle:
                            TextStyle(color: PrimaryColor.withOpacity(0.5)),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
