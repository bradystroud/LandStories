import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:land_stories/Database/getW3W.dart';

import 'dart:async';
import 'dart:convert';

import '../Database/Database.dart';
import '../Database/StoryModel.dart';
import '../widgets/textField.dart';

class NewStory extends StatefulWidget {
  @override
  _NewStoryState createState() => _NewStoryState();
}

class _NewStoryState extends State<NewStory> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text("New Story"),
        ),
        body: NewStoryDetails());
  }
}

Future<What3Words> fetchW3W(lat, long) async {
  String url = 'https://api.what3words.com/v3/convert-to-3wa?coordinates=' +
          lat +
          ',' +
          long +
          '&language=en&key=6U7VA8V0';

  final response = await http.get(url).then((onValue){
            print("val2");
            print(onValue);
          });
  print(await response);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(What3Words.fromJson(json.decode(response.body)));
    return What3Words.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class What3Words {
  final String words;

  What3Words({this.words});

  factory What3Words.fromJson(Map<String, dynamic> json) {
    return What3Words(
      words: json['words'],
    );
  }
}

class NewStoryDetails extends StatefulWidget {
  @override
  _NewStoryDetailsState createState() => _NewStoryDetailsState();
}

class _NewStoryDetailsState extends State<NewStoryDetails> {
  Position _location = Position(latitude: 0.0, longitude: 0.0);
  Future<Album> futureAlbum;

  void _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    fetchW3W(location.latitude.toString(), location.longitude.toString());

    void runMyFuture() {
      fetchW3W(location.latitude.toString(), location.longitude.toString()).then((value) {
        print("object");
        print(value);
      });
    }

    runMyFuture();

    setState(() {
      _location = location;
    });
  }

  void initState() {
    super.initState();
    _displayCurrentLocation();
    futureAlbum = fetchAlbum(_location.latitude.toString(), _location.longitude.toString());
  }

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFieldWidget("Story title", 30, controller1),
          TextFieldWidget("Story description", 100, controller2),
          Material(child: Text("${_location.longitude}" + " ${_location.latitude}")),
          FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Material(child: Text(snapshot.data.words));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
          FlatButton(
            child: Text("Get location"),
            onPressed: () async {
              // getLoc();
              _displayCurrentLocation();
              print(_location);
            },
          ),
          FlatButton(
            onPressed: () async {
              Story newStory = Story(
                heading: controller1.text,
                context: controller2.text,
                status: false,
              );
              await DBProvider.db.newStory(newStory);
              setState(() {});
              print("Added " + controller1.text + " and " + controller2.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
