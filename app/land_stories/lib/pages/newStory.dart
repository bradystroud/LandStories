import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import '../Database/getW3W.dart';
import '../Database/Database.dart';
import '../Database/Models.dart';
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

class NewStoryDetails extends StatefulWidget {
  @override
  _NewStoryDetailsState createState() => _NewStoryDetailsState();
}

class _NewStoryDetailsState extends State<NewStoryDetails> {
  Future<What3Words> futureWhat3Words;

  Future<Position> _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {});
    return location;
  }

  void initState() {
    super.initState();
    _displayCurrentLocation().then((value) {
      futureWhat3Words = fetchWhat3Words(
        value.latitude.toString(),
        value.longitude.toString(),
      );
    });
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
          FutureBuilder<What3Words>(
            future: futureWhat3Words,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                print(snapshot.data.words);
                return Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: '/// ',
                        style: TextStyle(color: Colors.red),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'W3W Location',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: snapshot.data.words),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
              // By default, show a loading spinner.
            },
          ),
          FlatButton(
            onPressed: () async {
              Story newStory = Story(
                heading: controller1.text,
                context: controller2.text,
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
