import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'  as http;

void main() => runApp(new ListPage());

class ListPage extends StatefulWidget {
  var title;

  ListPage({@required this.title});

  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Liste des émissions diffusées"),
          backgroundColor: Color.fromARGB(150, 13, 150, 173),
        ),

        body: Center(
        child: FutureBuilder<List>(
            future: fetchplays(),
            //appel de la fonction depuis le serveur kingRadio
            builder: (context, AsyncSnapshot<List> snapshot) {
              //snapshot pour garder la liste
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Text('Error');
                  } else {
                    return PlayLists(
                      plays: snapshot.data,
                    );
                  }
              }
            }),
      )),
    );
  }
}

class ListPlay {
  final String started_at;
  final String end_at;
  final double duration;
  final String title;
  final String artist;
  final String album;
  final bool is_live;

  const ListPlay({
    @required this.started_at,
    @required this.end_at,
    @required this.duration,
    @required this.title,
    @required this.artist,
    @required this.album,
    @required this.is_live,
  });

  factory ListPlay.fromJson(Map<String, dynamic> json) {
    return ListPlay(
      started_at: json["started_at"] as String,
      end_at: json['end_at'] as String,
      duration: json['duration'] as double,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json["album"] as String,
      is_live: json['is_live'] as bool,
    );
  }
}

class PlayLists extends StatelessWidget {
  final List<ListPlay> plays;

  PlayLists({Key key, this.plays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: plays.length,
        itemBuilder: (context, int index) {
          return Card(
            child: ListTile(
                leading: Icon( plays[index].is_live ? Icons.record_voice_over_outlined :Icons.music_note_outlined),
                title:   Text(plays[index].title) ,
                subtitle:
                ListBody(
                  children: [
                    Text( plays[index].artist != null ? plays[index].artist.toString() : "" + " \n"),
                      Text( (plays[index].started_at != null) ?
                    DateP(plays[index].started_at):'' ) ,

                  ],
                )
            ),
          );
        });
  }
}



String DateP(String date){

  DateTime parseDt = DateTime.parse(date).toLocal();
  print(parseDt);
  return parseDt.toString();
}

List<ListPlay> analyseList(String responseBody) {
  final parsedJson = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsedJson.map<ListPlay>((json) => ListPlay.fromJson(json)).toList();
}

Future<List<ListPlay>> fetchplays() async {

  final response = await http.get(Uri.parse(
      "https://api.radioking.io/widget/radio/sion-radio/track/ckoi?limit=20"));
  return analyseList(response.body);
}
