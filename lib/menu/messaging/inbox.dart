import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:user_management/global/behavior.dart';
import 'package:user_management/global/color.dart';
import 'package:user_management/global/url.dart';
import 'package:user_management/menu/messaging/detailInbox.dart';
import 'package:http/http.dart' as http;

class Inbox extends StatefulWidget {
  Inbox({this.username});
  final String username;

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  Future<List> getInbox() async {
    final response =
        await http.get("$BASE_URL/getInbox.php?receiver=${widget.username}");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getInbox(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: PrimaryColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              Icon(
                                Icons.message_outlined,
                                color: SecondaryColor.withOpacity(0.1),
                                size: MediaQuery.of(context).size.width * 0.9,
                              ),
                              Text(
                                "INBOX",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: SecondaryColor.withOpacity(0.1),
                                ),
                              )
                            ],
                          ),
                        )),
                    ScrollConfiguration(
                      behavior: NoScrollGrow(),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              child: Card(
                                color: SecondaryColor.withOpacity(0.75),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.message, size: 50),
                                      trailing: Wrap(
                                        children: [
                                          Icon(
                                            Icons.circle_notifications,
                                            color: Colors.green[700],
                                          )
                                        ],
                                      ),
                                      title: Text(
                                        snapshot.data[i]['sender']
                                            .toUpperCase(),
                                        style: TextStyle(
                                            letterSpacing: 1.5, fontSize: 14),
                                      ),
                                      subtitle:
                                          Text(snapshot.data[i]['message']),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () => Navigator.of(context).push(
                                PageRouteTransition(
                                    builder: (context) => DetailInbox(
                                          data: snapshot.data,
                                          username: widget.username,
                                        ),
                                    animationType: AnimationType.fade),
                              ),
                            ),
                          );
                        },
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
                      "loading data ...",
                      style: TextStyle(color: SecondaryColor),
                    ),
                  ],
                ),
              ));
        });
  }
}
