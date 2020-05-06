import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../Database/Database.dart';
import '../Database/Models.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _currentSwitchValue = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Settings"),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Card(
              child: Container(
                child: ListTile(
                  leading: Text(
                    "Very important setting",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: CupertinoSwitch(
                    value: _currentSwitchValue,
                    onChanged: (value) {
                      print(
                          "switch flipped: " + _currentSwitchValue.toString());
                      setState(() {
                        _currentSwitchValue = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            // PlatformButton(
            // child: Text("Feedback"),
            // onPressed: () {
            //   _showDialouge();
            // },
            // ),
            PlatformButton(
              //Helpful button for testing the app
              child: Text("Insert testing data"),
              onPressed: () async {
                List stories = [
                  Story(
                      heading: "Saw a tree",
                      context: "Today I saw a beautiful tree at the park."),
                  Story(
                      heading: "Big flower",
                      context: "There was a massive flower on my walk"),
                  Story(
                    heading: "great trail",
                    context: "Their is a great trail at this location",
                  )
                ];
                List tasks = [
                  Task(
                    heading: "Saw a tree",
                    context: "Today I saw a beautiful tree at the park.",
                    due: DateTime.now().millisecondsSinceEpoch + 169420 ~/ 1000,
                  ),
                  Task(
                    heading: "Go for a ride",
                    context: "I need some exercise today.",
                    due: DateTime.now().millisecondsSinceEpoch + 10000 ~/ 1000,
                  ),
                  Task(
                    heading: "Study",
                    context:
                        "Study pythagoruses theorum for the test coming up.",
                    due: (DateTime.now().millisecondsSinceEpoch - 1000) ~/ 1000,
                  ),
                ];
                for (Story story in stories) {
                  await DBProvider.db.newStory(story);
                  print("Added " + story.heading + " and " + story.context);
                }
                for (Task task in tasks) {
                  await DBProvider.db.newTask(task);
                  print("Added " + task.heading + " and " + task.context);
                }
              },
            ),
            PlatformButton(
              child: Text("Delete all"),
              onPressed: () async {
                await DBProvider.db.deleteAll();
              },
            )
          ],
        ),
      ),
    );
  }

  // void _showDialouge() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return PlatformAlertDialog(
  //         title: Text("Feedback"),
  //         content: Text("Help me improve the app by sending me some feedback."),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text("Cancel"),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           FlatButton(child: Text("Ok"), onPressed: () {}
  //               ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
