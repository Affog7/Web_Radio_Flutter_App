
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sion_radio/pages/home.dart';
import 'package:http/http.dart' as http;

import 'Start/init.dart';
import 'Start/splash_screen.dart';

void main() {
  runApp(InitializationApp());
}

class InitializationApp extends StatelessWidget {

  final Future _initFuture = Init.initialize();





  @override

  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Initialization',
      color:  Color.fromRGBO( 255, 255, 255,1),

      home: FutureBuilder(

        future: _initFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return MyAppA(title: "SION RADIO");
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}