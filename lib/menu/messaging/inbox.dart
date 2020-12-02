import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:user_management/global/behavior.dart';
import 'package:user_management/global/color.dart';
import 'package:user_management/menu/messaging/detailInbox.dart';

class Inbox extends StatefulWidget {
  Inbox({Key key}) : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
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
                    Icons.message_outlined,
                    color: SecondaryColor.withOpacity(0.3),
                    size: MediaQuery.of(context).size.width * 0.9,
                  ),
                )),
            ScrollConfiguration(
              behavior: NoScrollGrow(),
              child: ListView.builder(
                itemCount: 5,
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
                            const ListTile(
                              leading: Icon(Icons.message, size: 50),
                              title: Text('Sender'),
                              subtitle: Text('contents'),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(
                        PageRouteTransition(
                            builder: (context) => DetailInbox(),
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
}
