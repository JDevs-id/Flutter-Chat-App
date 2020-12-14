import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_management/global/behavior.dart';
import 'package:user_management/global/color.dart';
import 'package:user_management/global/url.dart';

class NewMessage extends StatefulWidget {
  NewMessage({Key key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController contReceiver = TextEditingController();
  TextEditingController contMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void _send() {
      String formattedTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      FocusScope.of(context).unfocus();

      if (contReceiver.text == "") {
        showToastAlert("Input username receiver!");
      } else if (contMessage.text == "") {
        showToastAlert("Input your message!");
      } else {
        http.post("$BASE_URL/sendMessage.php", body: {
          "time": formattedTime,
          "message_id": "tri" + "to" + contReceiver.text,
          "message_id_invert": contReceiver.text + "to" + "tri",
          "sender": "tri",
          "receiver": contReceiver.text,
          "message": contMessage.text
        });
        contReceiver.text = "";
        contMessage.text = "";
        showToastAlert("Message success sended");
        //Navigator.of(context).pop();
      }
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
                    controller: contReceiver,
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
                    controller: contMessage,
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
