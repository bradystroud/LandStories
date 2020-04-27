import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../Database/Database.dart';

import '../Database/StoryModel.dart';
import '../widgets/textField.dart';

class Modify extends StatefulWidget {
  final Story story;

  Modify(this.story);
  @override
  _ModifyState createState() => _ModifyState(story);
}

class _ModifyState extends State<Modify> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  Story story;

  _ModifyState(this.story);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Modify Story"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFieldWidget(story.heading, 30, controller1),
            TextFieldWidget(story.context, 100, controller2),
            FlatButton(
              onPressed: () async {
                Story modifiedStory = Story(
                  id: story.id,
                  heading: checkNull(story.heading, controller1.text),
                  context: checkNull(story.context, controller2.text),
                  status: story.status,
                );
                await DBProvider.db.updateStory(modifiedStory);
                print(
                    "updated " + controller1.text + " and " + controller2.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            FlatButton(
              child: Text(
                "Delete",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await DBProvider.db.deleteStories(story.id);
                Navigator.pop(context);
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

String checkNull(story, val) {
  String newval;
  if (val == "") {
    newval = story;
  } else {
    return val;
  }
  return newval;
}
