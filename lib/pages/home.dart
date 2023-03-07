

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:http/http.dart' as http;
import 'package:sion_radio/pages/recordds.dart';
import 'package:sion_radio/widgets/drawer.dart';
import 'package:sion_radio/widgets/slider.dart';
import 'package:volume/volume.dart';

void main() => runApp(new MyAppA(title: '',));

class MyAppA extends StatefulWidget {
  var title="Accueil SION RADIO";

  MyAppA({@required this.title});

  @override
  _MyAppAState createState() => new _MyAppAState();
}

class _MyAppAState extends State<MyAppA> {
  static const streamUrl ="https://www.radioking.com/play/sion-radio";
    String title ='';

  bool isPlaying=false;
  AudioManager audioManager;
  int maxVol, currentVol=1;

  // init function
  @override
  void initState() {
    super.initState();
    Navigator.canPop(context);
    _getTimes();
    audioStart();
    playingStatus();

    MediaNotification.showNotification(title: "",isPlaying: isPlaying);

    MediaNotification.setListener('pause', () {
      setState(() => isPlaying = false);
      FlutterRadio.playOrPause(url: streamUrl);

    });

    MediaNotification.setListener('play', () {
      setState(() => isPlaying = true);
      FlutterRadio.playOrPause(url: streamUrl);

    });

    audioManager = AudioManager.STREAM_SYSTEM;
    initPlatformState(AudioManager.STREAM_MUSIC);
    updateVolumes();
_init();

  }

  Future<void> _init() async {
    if (await FlutterAudioRecorder.hasPermissions) {

    } else {
      ScaffoldMessenger.of(context).showSnackBar(

          new SnackBar(content: new Text("You must accept permissions")));
    }
  }

  Future<void> initPlatformState(AudioManager am) async {
    await Volume.controlVolume(am);
  }
  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
   // isPlaying=true;
    MediaNotification.showNotification(
        title: title, author: 'MA RADIO',isPlaying: false);
     //FlutterRadio.play(url: streamUrl);
    print('Audio Start OK');
  }
  Future<bool> _getTimes() async {
    // Construction de l'URL a appeler
    var url1 = 'https://api.radioking.io/widget/radio/sion-radio/track/current?format=text';
    // Appel

    var response = await http.get(Uri.parse(url1));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    title= response.body;
    return true;
  }
  void updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    print("maxVol: $maxVol, currentVol: $currentVol");
    setState(() {});
  }
  void setVol(int i) async {
    await Volume.setVol(i);
  }
  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, //this means the user must tap a button to exit the Alert Dialog
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bienvenue sur MA RADIO'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("À Propos de nous",style: TextStyle(color: Color.fromARGB(150, 13, 150, 173),fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                  Divider(),
                  Container(
                    child: Text("Version : 1.0"),
                  ),
                  Divider(),
                  Text('MA RADIO est une web radio chrétienne pour l\’évangélisation des peuples du monde entier.\n'
                      'Au programme: de la musique chrétienne,  une grille d\'émissions variées et la diffusion de messages bibliques pour le perfectionnement des saints en vue de l\’édification du Corps de Christ à travers le monde. \n'
                      'Sion Radio veut faire de chaque Chrétien, un véritable disciple du Seigneur.\n'
                      'Avec Sion Radio, vous avez la possibilité de bâtir votre foi chrétienne en quelque lieu que vous soyez .\n'
                      'Sion Radio est pour vous un bon moyen pour écouter les louanges de Dieu dans toutes les langues du monde.\n'
                      'Sion Radio, c\'est la radio des disciples.',style: TextStyle(fontFamily: 'italic',fontSize: 12)),

                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
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
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('MA RADIO',textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.fade,),
          backgroundColor: Color.fromARGB(150, 13, 150, 173),
          actions: [
            IconButton(
              icon: Icon(Icons.help_center),
              onPressed: (){
                _showMyDialog();
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        drawer: drawer(),

         body: new Container(

            child: ListView(
                padding: EdgeInsets.all(0),
              children: <Widget>[
                ComplicatedImageDemo(),
                Container(
                  padding: EdgeInsets.only(top: 20 ),
                  child: Image(
                    image:AssetImage("images/logo.jpg"),
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                  ),
                ),


                Container(
                  padding: EdgeInsets.only( top: 50,left: 8,right: 5),
                  alignment: Alignment.bottomCenter,
                  width: 250,
                  child :
                  isPlaying ?
                 new Text(
                    title,
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
                  ) :
                  new Text(
                    'Veuillez appuyer le boutton play ▶ ci-dessous pour\n jouer la radio...',
                     style: TextStyle(color: Color.fromARGB(150, 13, 150, 173),fontStyle: FontStyle.italic),
                  )

                ),
                Divider(height: 12,),
                Container(
margin: EdgeInsets.all(12),
                  padding: EdgeInsets.only(top: 50,right: 20),
                  child: Row(

                    children: [
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: IconButton(icon:
                          Icon(Icons.stop_circle_outlined,color: Colors.redAccent,size: 70,),

                            onPressed: (){
                              setState(() {
                                FlutterRadio.stop();
                                FlutterRadio.pause(url: streamUrl);
                                isPlaying = false;
                                MediaNotification.showNotification(
                                    title: title, author: 'MA RADIO',isPlaying: isPlaying);
                              });
                            },
                          ),
                        ),

                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child:
                          IconButton(icon: isPlaying? Icon(Icons.pause_circle_outline,size: 70,color: Colors.black,):
                          Icon(Icons.play_circle_outline,color: Colors.black,size: 70,),

                            onPressed: (){
                              setState(() {
                                isPlaying = !isPlaying;
                                FlutterRadio.playOrPause(url: streamUrl);

                                MediaNotification.showNotification(
                                    title: title, author: 'MA RADIO',isPlaying: isPlaying);

                              });
                            },
                          ),
                        ),

                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: IconButton(icon:
                          Icon(Icons.settings_voice,color: Colors.black,size: 70,),

                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute<void>(
                                      builder:(BuildContext context) {
                                        return MyAppR();
                                      }));
                            },
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 70),
                  child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_down_outlined,size: 40,),
                        onPressed: (){
                          currentVol--;
                          setVol(currentVol);
                          updateVolumes();
                        },
                      ),
                      (currentVol != null && maxVol != null)
                          ? Slider(
                        activeColor: Color.fromARGB(150, 13, 150, 173),

                        value: currentVol.toDouble(),
                        divisions: maxVol,
                        max: maxVol.toDouble(),
                        min: 0,
                        onChanged: (double d) {
                          setVol(d.toInt());
                          updateVolumes();
                        },
                      )
                          : Container(),
                      IconButton(
                        icon: Icon(Icons.volume_up_outlined,size: 40,),
                        onPressed: (){
                          currentVol++;
                          setVol(currentVol);
                          updateVolumes();
                        },
                      ),
                    ],
                  ),

                ),


              ],
            )),
      ),
    );
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }


}


