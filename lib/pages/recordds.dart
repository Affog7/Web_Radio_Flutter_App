import 'dart:async';
import 'dart:io' as io;


import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sion_radio/widgets/drawer.dart';

import 'home.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  return runApp(new MyAppR());
}

class MyAppR extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}


class _MyAppState extends State<MyAppR> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: SafeArea(
          child: new RecorderExample(),
        ),
      ),
    );
  }
}

class RecorderExample extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  RecorderExample({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new RecorderExampleState();
}

class RecorderExampleState extends State<RecorderExample> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: true,
          title: const Text('ENREGISTREMENT ',textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.fade,),
          backgroundColor: Color.fromARGB(150, 13, 150, 173),
         ),

        body:
        new Container(
          padding: EdgeInsets.all(0),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              Container(
                padding: EdgeInsets.only(bottom: 8),
                child:  Row(

                    children:[

                      new FlatButton(
                        onPressed: () {
                          switch (_currentStatus) {
                            case RecordingStatus.Initialized:
                              {
                                _start();
                                break;
                              }
                            case RecordingStatus.Recording:
                              {

                                _pause();
                                break;
                              }
                            case RecordingStatus.Paused:
                              {
                                _resume();
                                break;
                              }
                            case RecordingStatus.Stopped:
                              {
                                _init();
                                break;
                              }
                            default:
                              break;
                          }
                        },
                        child: _buildText(_currentStatus),

                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: IconButton(
                            icon:  Icon(Icons.stop_circle_outlined,size: 70,color : Colors.black),
                            onPressed:
                            _currentStatus != RecordingStatus.Unset ? _stop : null,
                          ),
                        ),

                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: IconButton(icon:  Icon(Icons.play_circle_fill_sharp,size: 70,color : Colors.red),
                            onPressed: onPlayAudio,
                          ),
                        ),

                      ),
                    ]
                ),
              ),


            Divider(),


             new Text("Statut : " +_buildSat(_currentStatus)),

              new Text(
                "Durée : ${_current?.duration.toString()}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
              //
              //  new Text('Puissance Avg: ${_current?.metering?.averagePower}'),
              //  new Text('Puissance Peak: ${_current?.metering?.peakPower}'),
              Container(
                padding: EdgeInsets.all(12),
                child: new Text("Fichier de l'enregistrement: ${_current?.path}"),
              ),

              //new Text("Format: ${_current?.audioFormat}"),
              //new Text(
              //  "isMeteringEnabled: ${_current?.metering?.isMeteringEnabled}"),
              //new Text("Extension : ${_current?.extension}"),4
              Divider(),
              new Text("SION RADIO",style: TextStyle(color: Color.fromARGB(150, 13, 150, 173),fontWeight: FontWeight.bold,),)
            ],

          ),
        ),




    );

  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/sion_radio_recorder_';
        String nomR;
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        nomR=customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
        customPath = appDocDirectory.path + nomR;


        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV,);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {

    await _recorder.pause();
    setState(() {

    });
  }

  _stop() async {
    var result = await _recorder.stop();

    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }




  Widget _buildText(RecordingStatus status) {

    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          return
                  Align(
                  alignment: FractionalOffset.center,
                  child: IconButton(icon:  Icon(Icons.mic_none_sharp,size: 70,color : Colors.red),

                  ),
                );
          break;
        }
      case RecordingStatus.Recording:
        {
          return
            Align(
              alignment: FractionalOffset.center,
              child: IconButton(icon:  Icon(Icons.mic_off_sharp,size: 70,color : Colors.black),

              ),
            );
          break;
        }
      case RecordingStatus.Paused:
        {
         return  Align(
              alignment: FractionalOffset.center,
              child: IconButton(icon:  Icon(Icons.analytics_sharp,size: 70,color : Colors.red),

              ),
            );
          break;
        }
      case RecordingStatus.Stopped:
        {
          return   Align(
              alignment: FractionalOffset.center,
              child: IconButton(icon:  Icon(Icons.restart_alt_sharp,size: 70,color : Colors.red),


              ),
            );
          break;
        }
      default:
        break;
    }
  }

  String _buildSat(RecordingStatus status) {

    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          return "Pas d'enregistrement en cours."        ;
          break;
        }
      case RecordingStatus.Recording:
        {
          return "Enregistrement en cours...";
          break;
        }
      case RecordingStatus.Paused:
        {
          return "Enregistrement arrêté !";
          break;
        }
      case RecordingStatus.Stopped:
        {
          return "Enregistrement fini !";
          break;
        }
      default:
        return "";
        break;
    }
  }

  void onPlayAudio() async {
    FlutterRadio.stop();
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
   }


}