import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:path_provider/path_provider.dart';



class MyAppRec extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyAppRec> {
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
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextButton(
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
                      //color: Colors.lightBlue,
                    ),
                  ),
                  new TextButton(
                    onPressed:
                    _currentStatus != RecordingStatus.Unset ? _stop : null,
                    child:
                    new Icon(Icons.stop_circle_outlined,color: Colors.red,),
                   // color: Colors.lightBlue,
                  ),

                  SizedBox(
                    width: 8,
                  ),
                  new TextButton(
                    onPressed: onPlayAudio,
                    child:
                    new Icon(Icons.play_circle_fill_sharp),
                   // color: Colors.lightBlue,
                  ),

                ],
              ),
              //   new Text("Status : $_currentStatus"),
              //  new Text('Puissance Avg: ${_current?.metering?.averagePower}'),
              //  new Text('Puissance Peak: ${_current?.metering?.peakPower}'),
              new Text("Fichier de l'enregistrement: ${_current?.path}"),
              //new Text("Format: ${_current?.audioFormat}"),
              //new Text(
              //  "isMeteringEnabled: ${_current?.metering?.isMeteringEnabled}"),
              //new Text("Extension : ${_current?.extension}"),
              new Text(
                  "Durée : ${_current?.duration.toString()}")
            ]),
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/sion_radio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

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
        ScaffoldMessenger.of(context).showSnackBar(
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
    setState(() {});
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
    Widget text ;
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = IconButton(
            icon: Icon(Icons.mic_none_rounded), onPressed: () {  },
          );
          break;
        }
      case RecordingStatus.Recording:
        {
          text = IconButton(
            icon: Icon(Icons.mic_off_rounded), onPressed: () {  },
          );
          break;
        }
      case RecordingStatus.Paused:
        {
          text = IconButton(
            icon: Icon(Icons.analytics_sharp), onPressed: () {  },
          );
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = IconButton(
            icon: Icon(Icons.restart_alt_sharp), onPressed: () {  },
          );
          break;
        }
      default:
        text= Text('');
        break;
    }
    return text;
  }

  void onPlayAudio() async {
    FlutterRadio.stop();
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }
}