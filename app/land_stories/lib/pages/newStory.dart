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
          W3WLocation(),
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
