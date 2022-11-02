import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:async';
import 'package:sion_radio/main.dart';
import 'package:sion_radio/pages/contact.dart';
import 'package:sion_radio/pages/equaliser.dart';
import 'package:sion_radio/pages/home.dart';
import 'package:sion_radio/pages/list_play.dart';
import 'package:sion_radio/pages/recordds.dart';
import 'package:sion_radio/pages/records.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class drawer extends StatelessWidget {


  Future<void> share() async {
    await FlutterShare.share(
        title: 'SION RADIO',
        text: 'Jouez la radio qui vous donne de la joie',
        linkUrl: "https://www.sionradiotv.cf",
        chooserTitle: 'SION RADIO');
  }

  @override


  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, //this means the user must tap a button to exit the Alert Dialog
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bienvenue sur SION RADIO'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('🔵 Jouez avec le boutton ▶',style: TextStyle(fontFamily: 'italic',fontSize: 12)),
                  Text('🔵 Mettre pause avec le boutton ⏸',style: TextStyle(fontFamily: 'italic',fontSize: 12)),
                  Text('🔵 Arrêtez avec le boutton ⏹',style: TextStyle(fontFamily: 'italic',fontSize: 12)),
                  Text('🔵 Enregistrez avec le boutton 🎙️️',style: TextStyle(fontFamily: 'italic',fontSize: 12)),
                  Text('🔵 Accédez au Menu avec le boutton ☰',style: TextStyle(fontFamily: 'italic',fontSize: 12)),
                  Text('🔵 Partagez la RADIO avec le boutton 🔀',style: TextStyle(fontFamily: 'italic',fontSize: 12)),
Divider(height: 12,),
                  TextButton(

                    child: Text('Plus d\'informations',style: TextStyle(color: Color.fromARGB(150, 13, 150, 173))),
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute<void>(
                            builder:(BuildContext context) {
                              return Contact();
                            }));
                  },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Quitter'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return Drawer(

      child: ListView(
        padding: EdgeInsets.only(top: 30),

        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("images/logo.jpg") ,alignment: Alignment.center,scale: 8),
            ), child: null,

          ),
         ListTile(
          leading: Icon(Icons.home),
           title: Text("Accueil",style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,),),
          onTap: (){
            Navigator.pop(context);

          },

         ),
          ListTile(
          leading: Icon(Icons.record_voice_over),
           title: Text("Enregistrement",style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,),),
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute<void>(
                    builder:(BuildContext context) {
                      return MyAppR();
                    }));
          },
         ),

          ListTile(
            leading: Icon(Icons.settings_applications),
            title: Text("Paramètres",style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,),),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute<void>(
                      builder:(BuildContext context) {
                        return SettingApp(title: "Deuxième page");
                      }));
            },
          ),

          ListTile(
            leading: Icon(Icons.perm_contact_cal_rounded),
            title: Text("Contacts",style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,),),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute<void>(
                      builder:(BuildContext context) {
                        return Contact();
                      }));
            },
          ),

          ListTile(
            leading: Icon(Icons.playlist_play_rounded),
            title: Text("Playlist",style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,),),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute<void>(
                      builder:(BuildContext context) {
                        return ListPage();
                      }));
            },
          ),ListTile(
            leading: Icon(Icons.supervised_user_circle_sharp),
            title: Text("Abonnez-Vous à la page",style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,),),
            onTap: () => launch("https://fr.radioking.com/radio/sion-radio"),
          ),
         Container(
           padding: EdgeInsets.only(top: 100,left: 90),
           transformAlignment: Alignment.center,
           child: Row(
             children: [
               FloatingActionButton(
                 onPressed: share,
                 child: const Icon(Icons.share),
                 backgroundColor: Color.fromARGB(150, 13, 150, 173),
               ),
               VerticalDivider(),
               FloatingActionButton(
                 onPressed: () {
                   _showMyDialog();
                 },
                 child: const Icon(Icons.help),
                 backgroundColor: Color.fromARGB(150, 13, 150, 173),
               ),
             ],
           ),
         ),
        ],
      ),
    );


  }




}

