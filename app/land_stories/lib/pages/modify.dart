import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../Database/Database.dart';
import '../Database/Models.dart';
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
      backgroundColor: Colors.blue,
      appBar: PlatformAppBar(
        title: Text("Modify Story"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFieldWidget(story.heading, 30, controller1),
            TextFieldWidget(story.context, 100, controller2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  color: Colors.white,
                  onPressed: () async {
                    Story modifiedStory = Story(
                      id: story.id,
                      heading: checkNull(story.heading, controller1.text),
                      context: checkNull(story.context, controller2.text),
                    );
                    await DBProvider.db.updateStory(modifiedStory);

                    Change change = Change(
                      //records change
                      storyid: story.id,
                      datetime: DateTime.now().toString(),
                      newValue: controller1.text + controller2.text,
                      oldValue: story.heading + story.context,
                    );
                    await DBProvider.db.newChange(change);
                    print("updated " +
                        controller1.text +
                        " and " +
                        controller2.text);

                    Navigator.pop(context, 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Save", style: TextStyle(fontSize: 15),),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Delete",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  onPressed: () async {
                    await DBProvider.db.deleteStories(story.id);
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                ),
              ],
            ),
            PlatformButton(
              child: Text("Add image"),
              onPressed: () {},
            )
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
