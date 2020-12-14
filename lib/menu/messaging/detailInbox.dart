import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_management/global/behavior.dart';
import 'package:user_management/global/color.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/global/url.dart';

class DetailInbox extends StatefulWidget {
  DetailInbox({this.sender, this.username});
  final String sender;
  final String username;

  @override
  _DetailInboxState createState() => _DetailInboxState();
}

class _DetailInboxState extends State<DetailInbox> {
  TextEditingController contMessage = TextEditingController();
  Future<List> getMessages() async {
    final response =
        await http.get("$BASE_URL/getMessages.php?username=${widget.username}");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    void _send() {
      String formattedTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      FocusScope.of(context).unfocus();

      if (contMessage.text != "") {
        http.post("$BASE_URL/sendMessage.php", body: {
          "time": formattedTime,
          "message_id": widget.username + "to" + widget.sender,
          "message_id_invert": widget.sender + "to" + widget.username,
          "sender": widget.username,
          "receiver": widget.sender,
          "message": contMessage.text
        });
        contMessage.text = "";
      } else {
        showToastAlert("Input your message");
      }
    }

    return FutureBuilder(
        future: getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: PrimaryColor,
              body: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: NoScrollGrow(),
                    child: ListView.builder(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.07,
                            bottom: 90),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int i) {
                          if (snapshot.data[i]['receiver'] == widget.username) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 60, bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: SecondaryColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[i]['message'],
                                          style:
                                              TextStyle(color: SecondaryColor),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            snapshot.data[i]['time'],
                                            style: TextStyle(
                                                color:
                                                    SecondaryColor.withOpacity(
                                                        0.75),
                                                fontSize: 8),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 60, bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: SecondaryColor.withOpacity(0.75),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[i]['message'],
                                          style: TextStyle(color: PrimaryColor),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            snapshot.data[i]['time'],
                                            style: TextStyle(
                                                color: PrimaryColor.withOpacity(
                                                    0.75),
                                                fontSize: 8),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                  Container(
                      color: SecondaryColor,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Center(
                          child: Text(
                        widget.sender.toUpperCase(),
                        style: TextStyle(
                            color: PrimaryColor, fontWeight: FontWeight.w900),
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
                            controller: contMessage,
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
                                hintStyle: TextStyle(
                                    color: PrimaryColor.withOpacity(0.5)),
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
                      "loading data ...",
                      style: TextStyle(color: SecondaryColor),
                    ),
                  ],
                ),
              ));
        });
  }
}
