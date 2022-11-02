import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(

      child:

      Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("images/logo.jpg"),alignment: Alignment.topCenter,width: 200,
          ),
          Text(
            "En cours de préparation...",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2 ,width: 200,
          child: CircularProgressIndicator() ,

          ),


        ],
      ),
    );
  }
}