import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

void main() => runApp(Share());

class Share extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Share> {
  String msg = 'https://www.radioking.com/play/sion-radio';
  String base64Image ="";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 30),
              RaisedButton(
                child: Text('share to twitter'),
                onPressed: () async {
                  var response = await FlutterShareMe().shareToTwitter(
                      url: 'https://github.com/lizhuoyuan', msg: msg);
                  if (response == 'success') {
                    print('navigate success');
                  }
                },
              ),
              RaisedButton(
                child: Text('share to WhatsApp'),
                onPressed: () {
                  FlutterShareMe()
                      .shareToWhatsApp(base64Image: base64Image, msg: msg);
                },
              ),
              RaisedButton(
                child: Text('share to WhatsApp Business'),
                onPressed: () {
                  FlutterShareMe()
                      .shareToWhatsApp4Biz(base64Image: base64Image, msg: msg);
                },
              ),
              RaisedButton(
                child: Text('share to shareFacebook'),
                onPressed: () {
                  FlutterShareMe().shareToFacebook(
                      url: 'https://github.com/lizhuoyuan', msg: msg);
                },
              ),
              RaisedButton(
                child: Text('share to System'),
                onPressed: () async {
                  var response = await FlutterShareMe().shareToSystem(msg: msg);
                  if (response == 'success') {
                    print('navigate success');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}