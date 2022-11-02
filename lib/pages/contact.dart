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
          companyName: 'EDS Telecoms',
          textColor: Colors.white,
          backgroundColor: Color.fromARGB(150, 13, 150, 173),
          email: 'contact@eds-telecom.net',
          // textFont: 'Sail',
        ),
        backgroundColor: Colors.teal,
        body: ContactUs(
            cardColor: Colors.white,
            textColor: Colors.teal.shade900,
            logo: AssetImage('images/logo.jpg'),
            email: 'contact@sionradiotv.cf',
            companyName: 'SION RADIO',
            companyColor: Colors.teal.shade100,
            phoneNumber: '+22997640719',
            website: 'https://www.sionradiotv.cf  ',
            //githubUserName: 'AbhishekDoshi26',
           // linkedinURL:'https://www.linkedin.com/in/abhishek-doshi-520983199/',
            tagLine: 'La radio des disciples',
            taglineColor: Colors.teal.shade100,
            //twitterHandle: 'AbhishekDoshi26',
            //instagram: '_abhishek_doshi',
            facebookHandle: 'radiodelajoie'),
      ),
    );
  }
}