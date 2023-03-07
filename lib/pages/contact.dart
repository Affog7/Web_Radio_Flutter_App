import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

void main() => runApp(Contact());

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: ContactUsBottomAppBar(
          companyName: 'MA_MARIALLE',
          textColor: Colors.white,
          backgroundColor: Color.fromARGB(150, 13, 150, 173),
          email: 'augustinaffognon2000@gmail.com',
          // textFont: 'Sail',
        ),
        backgroundColor: Colors.teal,
        body: ContactUs(
            cardColor: Colors.white,
            textColor: Colors.teal.shade900,
            logo: AssetImage('images/logo.jpg'),
            email: 'augustinaffognon2000@gmail.com',
            companyName: 'MA RADIO',
            companyColor: Colors.teal.shade100,
            phoneNumber: '+33 0 754269037',
            website: 'https://',
            githubUserName: 'Affog7',
            linkedinURL:'https://www.linkedin.com/in/augustin-affognon-54a867248/',
            tagLine: 'La radio du peuple',
            taglineColor: Colors.teal.shade100,
            //twitterHandle: '',
            //instagram: '',
            facebookHandle: '#'),
      ),
    );
  }
}
